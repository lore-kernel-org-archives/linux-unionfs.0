From: Miklos Szeredi <miklos@szeredi.hu>
Subject: overlayfs access checks on underlying layers
Date: Tue, 27 Nov 2018 20:55:00 +0100
Message-ID: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>, Vivek Goyal <vgoyal@redhat.com>, Ondrej Mosnacek <omosnace@redhat.com>, Paul Moore <pmoore@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Moving discussion from github[1] to here.

To summarize: commit 007ea44892e6 ("ovl: relax permission checking on
underlying layers") was added in 4.20-rc1 to make overlayfs access
checks on underlying "real" filesystems more consistent.  The
discussion leading up to this commit can be found at [2].  The commit
broke some selinux-testsuite cases, possibly indicating a security
hole opened by this commit.

The model this patch tries to follow is that if "cp --preserve=all"
was allowed to the mounter from underlying layer to the overlay layer,
then operation is allowed.  That means even if mounter's creds doesn't
provide permission to for example execute underying file X, if
mounter's creds provide sufficient permission to perform "cp
--preserve=all X Y"  and original creds allow execute on Y, then the
operation is allowed.  This provides consistency in the face of
copy-ups.  Consistency is only provided in sane setups, where mounter
has sufficient privileges to access both the lower and upper layers.

The model may not have been perfectly followed, or possibly the model
itself is flawed.  I'd like to better understand the issues here.

Thanks,
Miklos

[1]  https://github.com/SELinuxProject/selinux-kernel/issues/43#issuecomment-442148920
[2] https://marc.info/?t=152762608800002&r=1
