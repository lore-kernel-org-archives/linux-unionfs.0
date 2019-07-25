From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v10 3/5] overlayfs: add __get xattr method
Date: Thu, 25 Jul 2019 18:43:39 +0300
Message-ID: <CAOQ4uxi5S9HTx+wR1U_8vQ-6nyCozykWBZbZwiHhnXBGhXRz8Q@mail.gmail.com>
References: <20190724195719.218307-1-salyzyn@android.com> <20190724195719.218307-4-salyzyn@android.com>
 <CAOQ4uxjizC1RhmLe3qmfASk2M-Y+QEiyLL1yJXa4zXAEby7Tig@mail.gmail.com> <af254162-10bf-1fc5-2286-8d002a287400@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <af254162-10bf-1fc5-2286-8d002a287400@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jul 25, 2019 at 6:03 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> On 7/24/19 10:48 PM, Amir Goldstein wrote:
> > On Wed, Jul 24, 2019 at 10:57 PM Mark Salyzyn <salyzyn@android.com> wrote:
> >> Because of the overlayfs getxattr recursion, the incoming inode fails
> >> to update the selinux sid resulting in avc denials being reported
> >> against a target context of u:object_r:unlabeled:s0.
> > This description is too brief for me to understand the root problem.
> > What's wring with the overlayfs getxattr recursion w.r.t the selinux
> > security model?
>
> __vfs_getxattr (the way the security layer acquires the target sid
> without recursing back to security to check the access permissions)
> calls get xattr method, which in overlayfs calls vfs_getxattr on the
> lower layer (which then recurses back to security to check permissions)
> and reports back -EACCES if there was a denial (which is OK) and _no_
> sid copied to caller's inode security data, bubbles back to the security
> layer caller, which reports an invalid avc: message for
> u:object_r:unlabeled:s0 (the uninitialized sid instead of the sid for
> the lower filesystem target). The blocked access is 100% valid, it is
> supposed to be blocked. This does however result in a cosmetic issue
> that makes it impossible to use audit2allow to construct a rule that
> would be usable to fix the access problem.
>

Ahhh you are talking about getting the security.selinux.* xattrs?
I was under the impression (Vivek please correct me if I wrong)
that overlayfs objects cannot have individual security labels and
the only way to label overlayfs objects is by mount options on the
entire mount? Or is this just for lower layer objects?

Anyway, the API I would go for is adding a @flags argument to
get() which can take XATTR_NOSECURITY akin to
FMODE_NONOTIFY, GFP_NOFS, meant to avoid recursions.

Thanks,
Amir.
