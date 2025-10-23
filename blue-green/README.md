# Blue Green

Blue-green stratejisi yerleşik Kubernetes Deployment tarafından desteklenmez; ancak üçüncü taraf bir Kubernetes controller'ı aracılığıyla kullanılabilir.
Bu örnek, blue-green dağıtımını [Argo Rollouts](https://github.com/argoproj/argo-rollouts) ile nasıl uygulayacağınızı gösterir:

1. Argo Rollouts controller'ını kurun: https://github.com/argoproj/argo-rollouts#installation
2. Örnek bir uygulama oluşturun ve senkronize edin.

```
argocd app create --name blue-green --repo https://github.com/argoproj/argocd-example-apps --dest-server https://kubernetes.default.svc --dest-namespace default --path blue-green && argocd app sync bl[...]
```

Uygulama senkronize edildikten sonra `blue-green-helm-guestbook` servisini kullanarak erişebilirsiniz.

3. Blue-green dağıtım sürecini tetiklemek için imaj sürümü parametresini değiştirin:

```
argocd app set blue-green -p image.tag=0.2 && argocd app sync blue-green
```

Şimdi uygulama aynı anda `ks-guestbook-demo:0.1` ve `ks-guestbook-demo:0.2` imajlarını çalıştırır.
`ks-guestbook-demo:0.2` hâlâ `blue` olarak kabul edilir ve sadece önizleme servisi `blue-green-helm-guestbook-preview` üzerinden erişilebilirdir.

4. `ks-guestbook-demo:0.2`'yi `green` olarak terfi ettirmek için `Rollout` kaynağını patch'leyin:

```
argocd app patch-resource blue-green --kind Rollout --resource-name blue-green-helm-guestbook --patch '{ "status": { "verifyingPreview": false } }' --patch-type 'application/merge-patch+json'
```

Bu işlem `ks-guestbook-demo:0.2`'yi `green` durumuna geçirir ve `Rollout` `ks-guestbook-demo:0.1` çalıştıran eski replikayı siler.
