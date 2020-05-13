Return-Path: <SRS0=GnLN=63=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B66C2D0F6
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 02:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C1AC20714
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 02:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgEMCsM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 May 2020 22:48:12 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:54479 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725967AbgEMCsM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 May 2020 22:48:12 -0400
X-Greylist: delayed 1939 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2020 22:48:12 EDT
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id EC0D4D59DA1;
        Wed, 13 May 2020 12:15:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYgw0-0001n2-Jr; Wed, 13 May 2020 12:15:48 +1000
Date:   Wed, 13 May 2020 12:15:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC PATCH v2] ovl: suppress negative dentry in lookup
Message-ID: <20200513021548.GO2005@dread.disaster.area>
References: <20200512071313.4525-1-cgxu519@mykernel.net>
 <CAOQ4uxiA_Er_VA=m8ORovGyvHDFuGBS4Ss_ef5un5VJbrev3jw@mail.gmail.com>
 <20200512083217.GC13131@miu.piliscsaba.redhat.com>
 <CAOQ4uxgfPVvFh3cQNoKzL6Y3k1HWF9hWXXutuDCON0dCzmapwA@mail.gmail.com>
 <CAJfpegsUVirkfovV+FJPpBWW0dWcnX_HWP-YoYf8vs=-kNjmgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsUVirkfovV+FJPpBWW0dWcnX_HWP-YoYf8vs=-kNjmgg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=9VEQsqaHYZXffD-8WvkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 12, 2020 at 11:30:43AM +0200, Miklos Szeredi wrote:
> On Tue, May 12, 2020 at 10:55 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, May 12, 2020 at 11:32 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Tue, May 12, 2020 at 10:50:31AM +0300, Amir Goldstein wrote:
> 
> > > diff --git a/include/linux/namei.h b/include/linux/namei.h
> > > index a4bb992623c4..4896eeeeea46 100644
> > > --- a/include/linux/namei.h
> > > +++ b/include/linux/namei.h
> > > @@ -49,6 +49,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
> > >  /* LOOKUP_* flags which do scope-related checks based on the dirfd. */
> > >  #define LOOKUP_IS_SCOPED (LOOKUP_BENEATH | LOOKUP_IN_ROOT)
> > >
> > > +#define LOOKUP_NO_NEGATIVE     0x200000 /* Hint: don't cache negative */
> > > +
> >
> > The language lawyers will call this double negative, but I do
> > prefer this over LOOKUP_POSITIVE :-)
> 
> Maybe LOOKUP_NOCACHE_NEGATIVE...

"DONTCACHE" is the terminaology we've used for telling the inode
cache not to cache inodes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
