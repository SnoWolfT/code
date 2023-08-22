1. dnsLoadTest.sh is the script running in the pod to send DNS query. 

          echo "$(date -u +'%F %H:%M:%S.%3N'),${host},${dnsname},${result}" | grep "timed out"    <-- Only the timeout logs will be printed. You can modify this part if you need. 

  
2. dnsDeploy.yaml is to create pods to generate huge amount of DNS queries. change the number 299 to adjust the amount of DNS queries. And you can replace "www.bing.com" with the FQND which you want to query. 
  
          for i in {1..299} 
          do 
          ./dnsLoadTest.sh www.bing.com & 
          done
          ./dnsLoadTest.sh www.bing.com

            
3. Use the following command to check logs in the pods. 

            for i in `kubectl get pod | grep dnsloadtest | awk '{print $1}'`; do kubectl logs $i; done        
