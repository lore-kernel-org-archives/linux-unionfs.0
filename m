From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] fstest: add helper _require_fs_feature
Date: Fri, 14 Jul 2017 10:54:10 +0800
Message-ID: <20170714025410.GH2478@eguan.usersys.redhat.com>
References: <1499852605-27759-1-git-send-email-amir73il@gmail.com>
 <1499852605-27759-2-git-send-email-amir73il@gmail.com>
 <20170713124127.GG2478@eguan.usersys.redhat.com>
 <CAOQ4uxhGEExv1XqCsA47AbZN4JZESDTEn0yuat_S0ZaRhnWZpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752974AbdGNCyM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2017 22:54:12 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhGEExv1XqCsA47AbZN4JZESDTEn0yuat_S0ZaRhnWZpg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Jul 13, 2017 at 04:10:44PM +0300, Amir Goldstein wrote:
> On Thu, Jul 13, 2017 at 3:41 PM, Eryu Guan <eguan@redhat.com> wrote:
> > On Wed, Jul 12, 2017 at 12:43:24PM +0300, Amir Goldstein wrote:
> >> The helper is used to test if a specific filesystem feature can
> >> be enabled. Currently only implemented testing overlayfs features.
> >>
> >> Overalyfs features (e.g. redirect_dir, index) are configurable from
> >> Kconfig (the build default), by module parameter (the system default)
> >> and per mount using the mount option ${feature}=[on|off].
> >>
> >> The helper is going to be used by overlay tests, which depend
> >> on the inodes index feature.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>  common/rc | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 48 insertions(+)
> >>
> >> diff --git a/common/rc b/common/rc
> >> index b505365..260b48d 100644
> >> --- a/common/rc
> >> +++ b/common/rc
> >> @@ -3626,6 +3626,54 @@ _get_fs_sysfs_attr()
> >>       cat /sys/fs/${FSTYP}/${dname}/${attr}
> >>  }
> >>
> >> +# Print the value of a filesystem module parameter
> >> +# at /sys/module/$FSTYP/parameters/$PARAM
> >> +#
> >> +# Usage example (FSTYP=overlay):
> >> +#   _get_fs_module_param index
> >> +_get_fs_module_param()
> >> +{
> >> +     cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
> >> +}
> >> +
> >> +# Generic test for specific filesystem feature.
> >> +# Currently only implemented to test overlayfs features.
> >> +_require_fs_feature()
> >
> > I'd think if it should be renamed to _require_scratch_feature, because
> > it assumes $SCRATCH_DEV is present, and it reminds people it's using
> > SCRATCH_DEV with "scratch" in the name.
> 
> Right. makes sense. Do you need me to re-post or will you fix on commit?

You've acked it, I can fix it myself :)

Thanks,
Eryu
