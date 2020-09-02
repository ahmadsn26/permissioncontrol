# permissioncontrol


Permission Control for groups

Question 1:
What Resources will we use and how will they interact.?


So We have 2 groups 

1-	Developers 
2-	Ops


From the requirements what we need is a control over cloud resources and every group has their own roles which they will assume .

Assumptions:

1-	Our cloud provider is AWS.
2-	We only have to use terraform to complete the requirements mentioned in part 2 of the assignment
3-	We need resource control of our cloud envoirenment.



Possible Solution

Aws provides a fine grain solution for that with the help of 3 services.

1-	AWS Cognito federated identities ( identitiy pool)
2-	Aws Cognito user pool
3-	IAM

Federated identities does not have a database of their own and what they need is an external provider which keeps the user record and federated identities can assign iam roles to that user, here we can use google,facebook or other providers. We can also make use of cognito user pool as an identity provider for our identity pool and then let them assume role of either developer or ops and use those credentials to continue using aws services.


External sources that are a good reference for this solution

 https://aws.amazon.com/blogs/aws/new-amazon-cognito-groups-and-fine-grained-role-based-access-control-2/

https://thenewstack.io/understanding-aws-cognito-user-and-identity-pools-for-serverless-apps/#:~:text=User%20Pools%20vs.&text=User%20Pools%20also%20provide%20your,through%20a%20separate%20Identity%20Provider.

 



