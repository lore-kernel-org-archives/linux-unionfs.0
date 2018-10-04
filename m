From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] fs: fix access beyond unterminated strings in prints
Date: Thu, 04 Oct 2018 16:05:00 +0100
Message-ID: <32347.1538665500@warthog.procyon.org.uk>
References: <20180928180048.14259-1-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180928180048.14259-1-amir73il@gmail.com>
Content-ID: <32346.1538665500.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, Jan Harkes <jaharkes@cs.cmu.edu>, Mark Fasheh <mark@fasheh.com>
List-Id: linux-unionfs@vger.kernel.org

Amir Goldstein <amir73il@gmail.com> wrote:

> @@ -47,7 +47,7 @@ static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, unsig
>  	int type = 0;
>  
>  	if (length > CODA_MAXNAMLEN) {
> -		pr_err("name too long: lookup, %s (%*s)\n",
> +		pr_err("name too long: lookup, %s (%.*s)\n",

Use %pd instead?

David
