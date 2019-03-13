From: Richard Weinberger <richard@nod.at>
Subject: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 13:31:17 +0100
Message-ID: <4603533.ZIfxmiEf7K@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi!

overlayfs and fscrypt are not friends.
Currently it is not possible to use a fscrypt encrypted directory as upper 
directory with overlayfs.
The reason for that is, fscrypt implements ->d_revalidate().

>From fscrypt's point of view having ->d_revalidate() makes sense because it 
wants to hide/show encrypted filenames if someone loads or unlinks a key.

On the other hand, overlayfs makes sure that the upper directory cannot
change beneath it. Therefore it checks whether the upper directory is a remote 
filesystem by checking for ->d_revalidate() and refuses to mount if so.

In my little embedded Linux world it is common to use both UBIFS and 
overlayfs. Now with UBIFS being encrypted using fscrypt, overlayfs is a 
problem.
My current hack is not using fscrypt_d_ops in UBIFS. This works because on a 
typical embedded target you setup your crypto keys exactly once, right before 
you mount overlayfs in an initramfs.

But I'm sure this problem will hit sooner or later users of ext4 and f2fs too.
Therefore I'd like to discuss possible solutions.

So far I see two options:

1. Get rid of ->d_revalidate() in fscrypt.
Maybe we find a way to return a dentry via ->lookup() which is not cached at 
all and therefore no ->d_revalidate() is needed. If unreadable and encrypted
filename lookups are slow, so what?
AFAIU this approach is impossible in the current dcache design since it is not 
allowed to have more than one dentry to the same file.

2. Teach overlayfs to deal with a upper that has ->d_revalidate().
Given the complexity of overlayfs I'm not sure how feasible this is.
But I'm no overlayfs expert, maybe I miss something.

What else could we do?

Thanks,
//richard
