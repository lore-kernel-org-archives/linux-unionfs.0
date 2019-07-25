From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v10 4/5] overlayfs: internal getxattr operations without
 sepolicy checking
Date: Thu, 25 Jul 2019 18:51:36 +0300
Message-ID: <CAOQ4uxhE77ZvUBv_ZLhSf8fdsWcJJkewjZAQKbgw3BdvgjRUOA@mail.gmail.com>
References: <20190724195719.218307-1-salyzyn@android.com> <20190724195719.218307-5-salyzyn@android.com>
 <CAOQ4uxhtASSymEOdh4XByXbxWO2_ZivzqjBrgK7jB3fWXLqr_w@mail.gmail.com> <20df8497-17ea-27db-43c8-fcd73633e7f3@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20df8497-17ea-27db-43c8-fcd73633e7f3@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jul 25, 2019 at 5:37 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> Thanks for the review.
>
> On 7/25/19 4:00 AM, Amir Goldstein wrote:
> > On Wed, Jul 24, 2019 at 10:57 PM Mark Salyzyn <salyzyn@android.com> wrote:
> >> Check impure, opaque, origin & meta xattr with no sepolicy audit
> >> (using __vfs_getxattr) since these operations are internal to
> >> overlayfs operations and do not disclose any data.  This became
> >> an issue for credential override off since sys_admin would have
> >> been required by the caller; whereas would have been inherently
> >> present for the creator since it performed the mount.
> >>
> >> This is a change in operations since we do not check in the new
> >> ovl_vfs_getxattr function if the credential override is off or
> >> not.  Reasoning is that the sepolicy check is unnecessary overhead,
> >> especially since the check can be expensive.
> > I don't know that this reasoning suffice to skip the sepolicy checks
> > for overlayfs private xattrs.
> > Can't sepolicy be defined to allow get access to trusted.overlay.*?
>
> Because for override credentials off, _everyone_ would need it (at least
> on Android, the sole user AFAIK, and only on userdebug builds, not user
> builds), and if everyone is special, and possibly including the random
> applications we add from the play store, then no one is ...
>

OK. I am convinced.

One weak argument in favor of the patch:
ecryptfs also uses __vfs_getxattr for private xattrs.

Thanks,
Amir.
