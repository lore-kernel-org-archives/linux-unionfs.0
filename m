From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v12 0/5] overlayfs override_creds=off
Date: Tue, 30 Jul 2019 14:37:48 -0700
Message-ID: <36b08762-3bd5-b7de-85c1-508e367971b1@schaufler-ca.com>
References: <20190730172904.79146-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190730172904.79146-1-salyzyn@android.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Linux Security Module list <linux-security-module@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On 7/30/2019 10:28 AM, Mark Salyzyn wrote:
> Patch series:

Please add linux-security-module@vger.kernel.org to the CC
for all changes affecting handling of security xattrs.

>
> overlayfs: check CAP_DAC_READ_SEARCH before issuing exportfs_decode_fh
> Add flags option to get xattr method paired to __vfs_getxattr
> overlayfs: handle XATTR_NOSECURITY flag for get xattr method
> overlayfs: internal getxattr operations without sepolicy checking
> overlayfs: override_creds=off option bypass creator_cred
>
> The first four patches address fundamental security issues that should
> be solved regardless of the override_creds=off feature.
> on them).
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
> v12:
> - Restore squished out patch 2 and 3 in the series,
>   then change algorithm to add flags argument.
>   Per-thread flag is a large security surface.
>
> v11:
> - Squish out v10 introduced patch 2 and 3 in the series,
>   then and use per-thread flag instead for nesting.
> - Switch name to ovl_do_vds_getxattr for __vds_getxattr wrapper.
> - Add sb argument to ovl_revert_creds to match future work.
>
> v10:
> - Return NULL on CAP_DAC_READ_SEARCH
> - Add __get xattr method to solve sepolicy logging issue
> - Drop unnecessary sys_admin sepolicy checking for administrative
>   driver internal xattr functions.
>
> v6:
> - Drop CONFIG_OVERLAY_FS_OVERRIDE_CREDS.
> - Do better with the documentation, drop rationalizations.
> - pr_warn message adjusted to report consequences.
>
> v5:
> - beefed up the caveats in the Documentation
> - Is dependent on
>   "overlayfs: check CAP_DAC_READ_SEARCH before issuing exportfs_decode_fh"
>   "overlayfs: check CAP_MKNOD before issuing vfs_whiteout"
> - Added prwarn when override_creds=off
>
> v4:
> - spelling and grammar errors in text
>
> v3:
> - Change name from caller_credentials / creator_credentials to the
>   boolean override_creds.
> - Changed from creator to mounter credentials.
> - Updated and fortified the documentation.
> - Added CONFIG_OVERLAY_FS_OVERRIDE_CREDS
>
> v2:
> - Forward port changed attr to stat, resulting in a build error.
> - altered commit message.
>
