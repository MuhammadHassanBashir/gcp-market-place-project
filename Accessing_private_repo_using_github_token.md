To create a token with read access to your four private repositories, follow these steps:

GitHub
    
    1- Create a Personal Access Token (PAT):

    Go to GitHub and sign in to your account.
    In the upper-right corner, click on your profile picture and then Settings.
    In the left sidebar, click Developer settings.
    Click Personal access tokens > Tokens (classic).
    Click Generate new token.
    Provide a note for your token, like "Read access to private repos".
    Set the expiration date for the token (choose "No expiration" if you want it to be permanent).
    Under Select scopes, check the following:
    repo (This gives full control of private repositories. Since you only need read access, it’s the minimal required scope).
    Optionally, you can select additional scopes if needed.
    Click Generate token.
    Copy the token to a safe place. You won’t be able to see it again.
    
    2-Use the Token to Clone Repositories:
    
      When cloning the repositories, use the following command in your terminal:

      git clone https://<your-token>@github.com/your-username/repo-name.git

      Replace <your-token> with the actual token you generated, your-username with your GitHub username, and repo-name with the name of the repository you want to clone.

    3- Access Multiple Repositories:

    Repeat the above git clone command for each of the four repositories using the same token.
    
Example:
    
    If your token is ghp_abc123xyz, your GitHub username is hassan, and the repository name is private-repo, the command would be:

    git clone https://ghp_abc123xyz@github.com/hassan/private-repo.git
    
    This will give you read access to clone the repositories using the generated token.

    Here are the git clone commands using your token:


    git clone https://github_access_token@github.com/Aretec-Inc/uploader-trigger-cf.git
    git clone https://github_access_token@github.com/Aretec-Inc/document-status-cf.git
    git clone https://github_access_token@github.com/Aretec-Inc/image-process-cf.git
    git clone https://github_access_token@github.com/Aretec-Inc/metadata-extractor-cf.git
    git clone https://github_access_token@github.com/Aretec-Inc/pdf-convert-cf.git

    You can run each command to clone the respective repositories using your GitHub token.






