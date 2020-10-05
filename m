Return-Path: <SRS0=dnFs=DM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE15C4363A
	for <linux-unionfs@archiver.kernel.org>; Mon,  5 Oct 2020 17:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8F8220853
	for <linux-unionfs@archiver.kernel.org>; Mon,  5 Oct 2020 17:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgJERNJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 13:13:09 -0400
Received: from relay.sw.ru ([185.231.240.75]:53084 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgJERNJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Oct 2020 13:13:09 -0400
Received: from [192.168.15.249] (helo=alex-laptop)
        by relay3.sw.ru with smtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1kPU22-0039XN-Av; Mon, 05 Oct 2020 20:12:14 +0300
Date:   Mon, 5 Oct 2020 20:12:22 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     miklos@szeredi.hu, Amir Goldstein <amir73il@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        David Howells <dhowells@redhat.com>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] overlayfs: add OVL_IOC_GETINFOFD ioctl that opens
 ovlinfofd
Message-Id: <20201005201222.d1f42917d060a5f7138b6446@virtuozzo.com>
In-Reply-To: <83d78791-b650-c8d5-e18a-327d065d53d7@infradead.org>
References: <20201004192401.9738-1-alexander.mikhalitsyn@virtuozzo.com>
        <20201005170227.11340-1-alexander.mikhalitsyn@virtuozzo.com>
        <83d78791-b650-c8d5-e18a-327d065d53d7@infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 5 Oct 2020 10:08:42 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 10/5/20 10:02 AM, Alexander Mikhalitsyn wrote:
> >  #define	OVL_IOC_GETLWRFHNDLSNUM			_IO('o', 1)
> >  // DISCUSS: what if MAX_HANDLE_SZ will change?
> >  #define	OVL_IOC_GETLWRFHNDL			_IOR('o', 2, struct ovl_mnt_opt_fh)
> >  #define	OVL_IOC_GETUPPRFHNDL			_IOR('o', 3, struct ovl_mnt_opt_fh)
> >  #define	OVL_IOC_GETWRKFHNDL			_IOR('o', 4, struct ovl_mnt_opt_fh)
> > +#define	OVL_IOC_GETINFOFD			_IO('o', 5)
> 
> Hi,
> 
> Quoting (repeating) from
> https://lore.kernel.org/lkml/9cd0e9d1-f124-3f2d-86e6-e6e96a1ccb1e@infradead.org/:
> 
> This needs to have Documentation/userspace-api/ioctl/ioctl-number.rst
> updated also.
> 
> ...
> 
> Are you waiting until it's past RFC stage?
> 
> thanks.
> -- 
> ~Randy
> 

Hi,

thank you! I will prepare this change too when we
decide which ioctls to add. ;)

Regards,
Alex.
