Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD98C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 14:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0DF22065C
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 14:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgFEO5G (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 10:57:06 -0400
Received: from relay.sw.ru ([185.231.240.75]:33218 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbgFEO5G (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 10:57:06 -0400
Received: from [192.168.15.111] (helo=alex-laptop)
        by relay3.sw.ru with smtp (Exim 4.93)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1jhDmB-0002Ls-6G; Fri, 05 Jun 2020 17:56:55 +0300
Date:   Fri, 5 Jun 2020 17:56:58 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrey Vagin <avagin@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements
Message-Id: <20200605175658.99b977a202d0ffb6c7cf5a04@virtuozzo.com>
In-Reply-To: <CAOQ4uxhkaGJf=duHO-k7UxTKJmGjFpQnfnn8-tRdG2cQZaLq3A@mail.gmail.com>
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
        <CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com>
        <AM6PR08MB36394A00DC129791CC89296AE8890@AM6PR08MB3639.eurprd08.prod.outlook.com>
        <CAOQ4uxisdLt-0eT1R=V1ihagMoNfjiTrUdcdF2yDgD4O94Zjcw@mail.gmail.com>
        <fb79be2c-4fc8-5a9d-9b07-e0464fca9c3f@virtuozzo.com>
        <CAOQ4uxhhNx0VxJB=eLoPX+wt15tH3-KLjGuQem4h_R=0nfkAiA@mail.gmail.com>
        <20200605154438.408e5dc5522170c50463bbec@virtuozzo.com>
        <CAOQ4uxhkaGJf=duHO-k7UxTKJmGjFpQnfnn8-tRdG2cQZaLq3A@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 5 Jun 2020 17:36:10 +0300
Amir Goldstein <amir73il@gmail.com> wrote:

> > > While at it, you copy pasted the text:
> > >           For more information, see Documentation/filesystems/overlayfs.txt
> > > but there is no more information to be found.
> >
> > As far as I know documentation patches must be send to another mailing list.
> > Of course I have plan to add information to overlayfs documentation about new feature.
> >
> 
> Please send documentation patch together with the series
> to this list. its fine to wait with that until the concept is approved though.
> 

Yep, I will prepare patch and send.

> 
> > > > > And if this works for you, you don't have to export the layers ovl_fh in
> > > > > /proc/mounts, you can export them in numerous other ways.
> > > > > One way from the top of my head, getxattr on overlay root dir.
> > > > > "trusted.overlay" xattr is anyway a reserved prefix, so "trusted.overlay.layers"
> > > > > for example could work.
> > > >
> > > > Thanks xattr might be a good option, but still don't forget about (a)
> > > > and (b), users like to know all information about mount from
> > > > /proc/pid/mountinfo.
> > > >
> > >
> > > Let's stick to your use cases requirements. If you have other use cases
> > > for this functionality lay them out explicitly.
> >
> > Requirements is very simple, at "dump stage" we need to save all overlayfs mount options
> > sufficient to fully reconstruct overlayfs mount state on "restore stage". We already
> > have proof of concept implementation of Docker overlayfs mounts when docker is running in
> > OpenVZ container. In this case we fully dump all tree of mounts and all mount namespaces.
> > CRIU mounts restore procedure at first reconstruct mount tree in special separate subtrees
> > called "yards", then when all mounts is reconstructed we do "pivot_root" syscall. And
> > with overlayfs it was a problem, because we mounted overlayfs with lowerdir,workdir,upperdir
> > paths with mount namespace "yard" path prefix, and after restore in mount options user may see
> > that lowerdir,workdir,upperdir paths were changed... It's a problem. Also it makes second C/R
> > procedure is impossible, because after first C/R lowerdir,workdir,upperdir paths is invalidated
> > after pivot_root.
> >
> > Example for Docker (after first C/R procedure):
> >
> > options lowerdir=/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/docker/overlay2/l/4BLZ4WH6GZIVKJE5QF62QUUKVZ:/var/lib/docker/overlay2/l/7FYRGAXT35JMKTXCHDNCQO3HKT,upperdir=/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/docker/overlay2/30aa26fb5e5671fc0126f2fc0e84cc740ce6bf06ca6ad4ac877a3c60f5aceaf1/diff,workdir=/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/docker/overlay2/30aa26fb5e5671fc0126f2fc0e84cc740ce6bf06ca6ad4ac877a3c60f5aceaf1/work
> >
> 
> That reminds me.
> I've read somewhere that thoses symlinks l/4BLZ4WH6GZIVKJE5QF62QUUKVZ
> are meant to shorten the mount option string, because the mount
> options are limited by
> page size and with many lower layers limitation can reach.
> 
> That is one of the reasons that new mount API was created for (i.e. fsconfig()).
> I wonder if /proc/mounts also has a similar limitation on options size.
> I also wonder why docker doesn't chdir into /var/lib/docker/overlay2/
> before mounting overlay and use relative paths, though that would have
> been worse for CRIU.
> 
> So at least for the docker use case CRIU knows very well where the
> underlying filesytem is mounted (/var/lib/docker/overlay2/ or above).
> So if you got any API from overlayfs something like:
> getxattr("/var/lib/docker/overlay2/XYZ/merged",
> "trusted.overlay.layers.0.fh",..)
> which reads the ovl_fh encoding of layer 0 (upper) rootdir, CRIU
> can verify that uuid matches the filesystem mounted at /var/vol/docker/overlay2/
> and then call open_by_handle_at() to open fd and resolve it to a path
> under /var/vol/docker/overlay2.
> 
> I don't know if that provides what CRIU needs, but it would be no more
> than a few lines of code in overlayfs:
> 
> if (i < ofs->numlayer)
>     fh = ovl_encode_real_fh(ofs->layers[i].mnt->mnt_root, ...
> 

I will try to experiment with that. Thank you!

> Thanks,
> Amir.

-- 
Regards,
Alex.
