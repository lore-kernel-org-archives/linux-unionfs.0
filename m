From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v14 0/5] overlayfs override_creds=off & nested get xattr fix
Date: Wed, 23 Oct 2019 09:54:57 +0300
Message-ID: <CAOQ4uxjFqq0zA7V3A9s0h2om7AWY5AT-2sQ4z2G0Vk2gtf1M=w@mail.gmail.com>
References: <20191022204453.97058-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191022204453.97058-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Oct 22, 2019 at 11:45 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> Patch series:
>
> Mark Salyzyn (5):
>   Add flags option to get xattr method paired to __vfs_getxattr
>   overlayfs: check CAP_DAC_READ_SEARCH before issuing exportfs_decode_fh
>   overlayfs: handle XATTR_NOSECURITY flag for get xattr method
>   overlayfs: internal getxattr operations without sepolicy checking
>   overlayfs: override_creds=off option bypass creator_cred
>
> The first four patches address fundamental security issues that should
> be solved regardless of the override_creds=off feature.
>
> The fifth adds the feature depends on these other fixes.
>
> By default, all access to the upper, lower and work directories is the
> recorded mounter's MAC and DAC credentials.  The incoming accesses are
> checked against the caller's credentials.
>
> If the principles of least privilege are applied for sepolicy, the
> mounter's credentials might not overlap the credentials of the caller's
> when accessing the overlayfs filesystem.  For example, a file that a
> lower DAC privileged caller can execute, is MAC denied to the
> generally higher DAC privileged mounter, to prevent an attack vector.
>
> We add the option to turn off override_creds in the mount options; all
> subsequent operations after mount on the filesystem will be only the
> caller's credentials.  The module boolean parameter and mount option
> override_creds is also added as a presence check for this "feature",
> existence of /sys/module/overlay/parameters/overlay_creds
>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
> v14:
> - Rejoin, rebase and a few adjustments.
>
> v13:
> - Pull out first patch and try to get it in alone feedback, some
>   Acks, and then <crickets> because people forgot why we were doing i.

Mark,

I do not see the first patch on fsdevel
and I am confused from all the suggested APIs
I recall Christoph's comment on v8 for not using xattr_gs_args
and just adding flags to existing get() method.
I agree to that comment.

I remember asking - don't remember the answer -
do you have any testing for this feature?
I have a WIP branch to run unionmount-testsuite not as root,
which is a start, but I didn't get to finish the work.
Let me know if you want to take up this work.

Thanks,
Amir.
