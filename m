Return-Path: <vgoyal@redhat.com>
Date: Thu, 2 Aug 2018 08:30:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH v2 9/9] ovl: check redirect_dir feature when detect
 redirect xattr on dir
Message-ID: <20180802123013.GA753@redhat.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
 <20180731093727.26855-10-yi.zhang@huawei.com>
 <CAOQ4uxgecg_TuCkQrtY7Oj-vL34Mdj-FBsMgQByaKfNWZKFkkQ@mail.gmail.com>
 <CAOQ4uxhsUekpXAKX5Nt8T9gFGK1fmkxWWYW4-aO02NM-g8FDvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhsUekpXAKX5Nt8T9gFGK1fmkxWWYW4-aO02NM-g8FDvA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Aug 01, 2018 at 02:35:27PM +0300, Amir Goldstein wrote:
> On Wed, Aug 1, 2018 at 2:30 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> >> After we introduce the fsck.overlay program, we could check and fix
> >> the inconsistency of feature set xattr, so it's a good opportunity
> >> check the redirect dir feature when we detect redirect xattr on
> >> directory in the underlying layer. If the feature is necessary
> >> (OVL_FS_V2 for all layers and OVL_FS_UPPER_V2 for upper layer) but
> >> the redirect dir feature is missing, the feature set is inconsistent
> >> and fsck.overlay is required.
> >>
> >> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> >> ---
> 
> The concept of this patch is fine, but I would really like to review
> it only after rebase with metacopy, because there are pretty big changes
> for lookup+redirecet in metacopy patches.
> And I would love to get Vivek's feedback on this patch.

I am just trying to understand what's going on on this patch series.

Zhangyi, There are lots of details in first email but high level picture
is missing. It would help if there was a README or 2-3 paragraphs
explaining what's the problem and how you are solving it. I feel
description directly jumps to  details of "how some problem is being
solved".  While it works for the people who know about it, I am 
scratching my head. Will be nice, if in next posting if you could
also describe, what's the problem you are solving.

> 
> Also, it might be enough just to check the feature bit inside
> ovl_check_redirect() and warn - I am not sure that failing the lookup
> is called for.

Without knowing much, I agreed that failing lookup feels little
drastic. A warning that running fsck.overlay is recommended, sounds
more appropriate.

Also agreed that its easier to review this after metadata only copy
up patches are merged. ovl_lookup() and friends have changed significantly
and once this patch is rebased on top of that, its easier to review.

Thanks
Vivek
