From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 3/3] nfs: Store and use inode in nfs_open_context
Date: Wed, 2 Mar 2016 09:57:24 -0600
Message-ID: <56D70D64.9010705@suse.de>
References: <1456855928-29913-1-git-send-email-rgoldwyn@suse.de>
 <1456855928-29913-4-git-send-email-rgoldwyn@suse.de>
 <CAHQdGtRu2nd54+tKQLPp2tvf1MpKw4-X8ESqx-8W4_zAov7hFA@mail.gmail.com>
 <56D6F84B.5040301@suse.de>
 <CAHQdGtSd8Sg-X7vGOJoVZZZZQFxfsdeOsHUcS5z09BOVwQ1pUw@mail.gmail.com>
 <CAHQdGtR1Ywp9JnO7mD5-tOy5wngsgp2OZBJyQx1hyaXpTNc54g@mail.gmail.com>
 <CAJfpegvm_E_K6_wwvuWnnm-D=tBEY=dq_frp8UObUysS4_Pixg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvm_E_K6_wwvuWnnm-D=tBEY=dq_frp8UObUysS4_Pixg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trond.myklebust@primarydata.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org



On 03/02/2016 08:43 AM, Miklos Szeredi wrote:
<snip>

>
>
> Not sure how any dentry seen by NFS became associated with overlayfs.
> Through ->f_path by any chance?
>

Yes, NFS extracts dentry from filp->f_path.dentry in fs/nfs/inode.c 
nfs_open(). What can it use to evaluate dentry?

-- 
Goldwyn
