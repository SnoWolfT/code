You can choose to replace the node name in the yaml file, **debugPod_Manual.yaml**.

Alternatively, you can use the script, **accessNode.sh**, and add the node name as the parameter. Here is one example.
```
tom [ ~ ]$ k get node
NAME                              STATUS   ROLES   AGE     VERSION
aks-migtest-14958771-vmss00001k   Ready    agent   4h27m   v1.25.11
aks-migtest-14958771-vmss00001l   Ready    agent   4h27m   v1.25.11
aks-migtest-14958771-vmss00001m   Ready    agent   4h27m   v1.25.11
tom [ ~ ]$ ./accessNode.sh aks-migtest-14958771-vmss00001m
pod/debugger-aks-migtest-14958771-vmss00001m created
debugger-aks-migtest-14958771-vmss00001m   1/1     Running     0          7s      10.224.0.10   aks-migtest-14958771-vmss00001m   <none>           <none>
root@aks-migtest-14958771-vmss00001M:/# chroot host
# bash
root@aks-migtest-14958771-vmss00001M:/# 
```
