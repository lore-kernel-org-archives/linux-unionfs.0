From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 03/15] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 15 Nov 2017 11:04:00 -0500
Message-ID: <20171115160400.GD13895@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
 <20171109205019.11409-4-vgoyal@redhat.com>
 <CAOQ4uxgRv2A9nWvf2Yo7m_7FtMdDQ05DLqCih4qiViBo4wxNng@mail.gmail.com>
 <CAOQ4uxjN+HyKKBN2sMbTDmt9FvUrpUsRsdbo8DBA0cso_OPmvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756489AbdKOQEB (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Nov 2017 11:04:01 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjN+HyKKBN2sMbTDmt9FvUrpUsRsdbo8DBA0cso_OPmvA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 10, 2017 at 09:14:49AM +0200, Amir Goldstein wrote:
> On Fri, Nov 10, 2017 at 9:07 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> By default metadata only copy up is disabled. Provide a mount option so
> >> that users can choose one way or other.
> >>
> >> Also provide a kernel config and module option to enable/disable
> >> metacopy feature.
> >>
> >> Like index feature, we verify on mount that upper root is not being
> >> reused with a different lower root. This hopes to get the configuration
> >> right and detect the copied layers use case. But this does only so
> >> much as we don't verify all the lowers. So it is possible that a lower is
> >> missing and later data copy up fails.
> >>
> >> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >
> > Fine, as long as Miklos agrees not to enforce exclusive dir lock,
> > it's fine by me.
> >
> > Please take a look at my ovl-features patches and say what you think.
> > It is time we started to enforce some order with all the inter-dependencies
> > between features.
> > With my proposal, it will make mounting an overlay with metacopy object
> > on older kernel slightly harder (but not impossible), so it can help admins
> > from tripping over themselves.
> >
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >
> 
> On second though, hold that Reviewed-by, there is one more thing
> that this patch should check, see path:
> "ovl: disable redirect_dir and index when no xattr support"
> from my verify_dir patches:
> https://github.com/amir73il/linux/commits/ovl-verify-dir
> 
> You may cherry-pick it at beginning of your series and then this
> patch should also disable metacopy on mount with noxattr with a warning to user,
> instead of silently not doing the metacopies, but claiming in mount options that
> metacopy is on.

Makes sense. Will do.

Vivek
