From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 31/35] Revert "vfs: add d_real_inode() helper"
Date: Wed, 18 Apr 2018 11:19:07 +0300
Message-ID: <CAOQ4uxgdWCWvwWgjUu06H=BeMxh-BVAjxVE5Ckj-poKRGgwvMQ@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-32-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-32-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Howard McLauchlan <hmclauchlan@fb.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 12, 2018 at 6:08 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> This reverts commit a118084432d642eeccb961c7c8cc61525a941fcb.
>
> No user of d_real_inode() remains, so it can be removed.
>

FYI, there is a new user in v4.17-rc1 added by commit
f0a2aa5a2a40 tracing/uprobe: Add support for overlayfs

Seems like this patch got merged without any CC to overlayfs
mailing list nor maintainer?

Not sure yet if overlayfs-rorw patches would allow reverting this
change.

Thanks,
Amir.
