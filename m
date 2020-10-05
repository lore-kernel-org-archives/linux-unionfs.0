Return-Path: <SRS0=dnFs=DM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA54C4363A
	for <linux-unionfs@archiver.kernel.org>; Mon,  5 Oct 2020 19:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31546208C3
	for <linux-unionfs@archiver.kernel.org>; Mon,  5 Oct 2020 19:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgJETkg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 15:40:36 -0400
Received: from relay.sw.ru ([185.231.240.75]:39730 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729302AbgJETkg (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Oct 2020 15:40:36 -0400
Received: from [192.168.15.249] (helo=alex-laptop)
        by relay3.sw.ru with smtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1kPWKi-003AjU-J6; Mon, 05 Oct 2020 22:39:40 +0300
Date:   Mon, 5 Oct 2020 22:39:48 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        David Howells <dhowells@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] overlayfs: add OVL_IOC_GETINFOFD ioctl that opens
 ovlinfofd
Message-Id: <20201005223948.6e9769ded3301b2d04a2bdae@virtuozzo.com>
In-Reply-To: <CAOQ4uxiGq40XLhjx_Nz1ymGj967QsMAj_PvuSKH1_4dX=dRMXA@mail.gmail.com>
References: <20201004192401.9738-1-alexander.mikhalitsyn@virtuozzo.com>
        <20201005170227.11340-1-alexander.mikhalitsyn@virtuozzo.com>
        <83d78791-b650-c8d5-e18a-327d065d53d7@infradead.org>
        <20201005201222.d1f42917d060a5f7138b6446@virtuozzo.com>
        <CAOQ4uxiGq40XLhjx_Nz1ymGj967QsMAj_PvuSKH1_4dX=dRMXA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 5 Oct 2020 20:22:47 +0300
Amir Goldstein <amir73il@gmail.com> wrote:

> On Mon, Oct 5, 2020 at 8:13 PM Alexander Mikhalitsyn
> <alexander.mikhalitsyn@virtuozzo.com> wrote:
> >
> > On Mon, 5 Oct 2020 10:08:42 -0700
> > Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > > On 10/5/20 10:02 AM, Alexander Mikhalitsyn wrote:
> > > >  #define    OVL_IOC_GETLWRFHNDLSNUM                 _IO('o', 1)
> > > >  // DISCUSS: what if MAX_HANDLE_SZ will change?
> > > >  #define    OVL_IOC_GETLWRFHNDL                     _IOR('o', 2, struct ovl_mnt_opt_fh)
> > > >  #define    OVL_IOC_GETUPPRFHNDL                    _IOR('o', 3, struct ovl_mnt_opt_fh)
> > > >  #define    OVL_IOC_GETWRKFHNDL                     _IOR('o', 4, struct ovl_mnt_opt_fh)
> > > > +#define    OVL_IOC_GETINFOFD                       _IO('o', 5)
> > >
> > > Hi,
> > >
> > > Quoting (repeating) from
> > > https://lore.kernel.org/lkml/9cd0e9d1-f124-3f2d-86e6-e6e96a1ccb1e@infradead.org/:
> > >
> > > This needs to have Documentation/userspace-api/ioctl/ioctl-number.rst
> > > updated also.
> > >
> > > ...
> > >
> > > Are you waiting until it's past RFC stage?
> > >
> > > thanks.
> > > --
> > > ~Randy
> > >
> >
> > Hi,
> >
> > thank you! I will prepare this change too when we
> > decide which ioctls to add. ;)
> >
> 
> Or... don't do ioctls and avoid the ABI headaches.
> If you are going to expose a seqfile I think it would be much prefered
> to do a /sys/fs/overlay/instance/<device minor>/layes file.
> 
> But that's just my opinion.
> 
> Thanks,
> Amir.

Hi!

Oh, yes, it's just another one choice for us ;)
I decided to create ioctl which opens fd for transferring
data about overlayfs.
Sure, let's look on sys fs. I will dive into it!

Thanks

Regards,
Alex.
