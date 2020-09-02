Return-Path: <SRS0=LI0E=CL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD43C433E7
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE65C20767
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTr3ik32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgIBPcJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgIBPcH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 2 Sep 2020 11:32:07 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A49C061244
        for <linux-unionfs@vger.kernel.org>; Wed,  2 Sep 2020 08:32:06 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p13so5360097ils.3
        for <linux-unionfs@vger.kernel.org>; Wed, 02 Sep 2020 08:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pCB1yKKRcH1OMdmXRD9WuYsbIXBG+DXAJcjldND1yp0=;
        b=rTr3ik32klBQqKzWO8SyCK/3SJHGmc3N6VLXmJEGJtMelxLwg6wreFl8gzo2wP4/dG
         oTqXu3KDxklxm4rwTaRPlsydHIaezdUsajO2bjk3487JJFtZwhqb14pTc2aAZLq8tXJZ
         jCDBxHIqdwoD7s+Hxq19jVjCmhwdjYbHupfyhFnsCKI86KCJ50m+VE+6IyLTotC84EgV
         xdaYPsR/CnzvXz3ZxLQj84ua+VAPKiSsg7BNBvetOoPekc7Q+2eZaWaoNXKhDoKILQb/
         XesKpZUUlJ48i+qjc6X/mvpL0ZwxDpQtttmBy/ro/IqaiSwCyjZFLB0yfHnZnHbUA739
         P/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pCB1yKKRcH1OMdmXRD9WuYsbIXBG+DXAJcjldND1yp0=;
        b=EDLthvU6GTLW8eZgSYL0kcF1APKU8QoCkXX6MYPbkQ2IR5KwOD9Kjk5PzQ/zIfo67C
         8BE816Z+SCx5cR4wTlXbY7F1fYcAfhfB2+stgm8OoJ4IhUlymmfYiJez2hO2T+r8oCel
         bRi/3E794Az59z6BOHdgYWb5olgZby5l3biSl6hdPczYose6bOnQhTLFwi8m3Y6wfTcu
         WzPIyzcQA6Gjo4pEvbzoPjLuHTa/4KRg+pIEIT434eueDseTcD+zTa4cMIBk2pZEX8EV
         7DDi6nFDD2447nu5p+Uf/wxU/k8g9IqsjooV/1yYNWjb+AlK1WjHl4skI5yfT8AK128J
         UsdQ==
X-Gm-Message-State: AOAM531zcDWU1QFIHT6tj0uBEZo0nQR8vp7dhG/FovrxmlQXoebHDUW3
        cO1wlA2Nas/ikMNCmEdm65EbAKnf6STzf7sp5LY8bcP5
X-Google-Smtp-Source: ABdhPJzeNReu3pvcq8lH+PdlG7gU/aLoXppFszriPUYFTJSD/3nHmrqWSg+BOq/F4FtrB7pJH5frn0OrkU27E2svm/E=
X-Received: by 2002:a05:6e02:c61:: with SMTP id f1mr915955ilj.137.1599060725735;
 Wed, 02 Sep 2020 08:32:05 -0700 (PDT)
MIME-Version: 1.0
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it> <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
 <20200902132921.GA1263242@redhat.com>
In-Reply-To: <20200902132921.GA1263242@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 2 Sep 2020 18:31:54 +0300
Message-ID: <CAOQ4uxiSpxCUCqPPRft-oz1H28N_cMFnTDwYh10gWYo2u0DtgA@mail.gmail.com>
Subject: Re: Frequent errors with OverlayFS on root
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Mauro Condarelli <mc5686@mclink.it>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 2, 2020 at 4:29 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Sep 02, 2020 at 06:34:12AM +0300, Amir Goldstein wrote:
> > On Wed, Sep 2, 2020 at 2:37 AM Mauro Condarelli <mc5686@mclink.it> wrote:
> > >
> > > Thanks Amir,
> > > comments inline below
> > >
> > > Regards
> > > Mauro
> > >
> > > On 9/1/20 8:43 PM, Amir Goldstein wrote:
> > >
> > > On Tue, Sep 1, 2020 at 9:01 PM Mauro Condarelli <mc5686@mclink.it> wrote:
> > >
> > > Hi,
> > > most likely this is not the right place to ask, please redirect me as needed.
> > >
> > > I'm trying to use OverlayFS to add (limited) write capability to a ReadOnly
> > > rootfs (SquashFS)
> > >
> > > Essentially (actual script is more complex, of course) boot-sequence includes:
> > >
> > > # /dev/mmcblk0p5: ext4 (upper+work+nwwroot+newroot/oldroot)
> > > # /dev/mmcblk0p6: SquashFS mounted on /
> > > mount /dev/mmcblk0p5 /overlay
> > > mount -t overlay overlay -o lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work  /overlay/newroot
> > > cd /overlay/newroot
> > > pivot_root . oldroot
> > > mount --move oldroot/dev /dev
> > > mount --move oldroot/proc /proc
> > >
> > > This works as expected, but, too often for comfort, some file
> > > (and sometime also directories) become unavailable due to error:
> > >
> > > overlayfs: invalid origin (ssh/sshd_config, ftype=8000, origin ftype=4000).
> > >
> > > File name changes, of course, but rest is fairly constant.
> > >
> > > This always happens when some file is written.
> > > Error persists reboots.
> > > Only way I found to "cure" the system is to go on "upper" and delete the file
> > > thus going back to "lower" version (in this case I should delete "/oldroot/overlay/upper/etc/ssh/sshd_config")
> > >
> > > This is a self-built kernel (Linux vocore 5.7.0 #2 PREEMPT Mon Aug 3 09:19:06 CEST 2020 mips GNU/Linux)
> > > on a custom target based on a SoC (MT7628).
> > >
> > > I am available to do any required test, but I have no idea about where to start.
> > >
> > > Any hint (or redirect) would be greatly appreciated.
> > >
> > > This is probably your problem:
> > > https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
> > >
> > > It surely looks like it is.
> > > I tried to follow the thread, but I'm unsure i grokked it .
> > >
> > > I am using OverlayFS (ext4 over a SquashFS) on rootfs in order to
> > > be able to update the whole system (changing SquashFS) while
> > > retaining customization (essentially tweaks in /etc/, host certificates
> > > and similar stuff) in an embedded target.
> > >
> > > To complicate matters I also have a dual system for fallback in case
> > > of faulty upgrade; this means I can switch from:
> > >   lower=part6, upper=part5, update will go into part7
> > > to
> > >   lower=part7, upper=part5, update will go into part6
> > >
> > > I don't need nfs at all, so exporting OverlayFS is not an issue,
> > > but it's unclear to me if this "lower swapping" is
> > > actually supported as I see:
> > >
> > > > > /me is again wondering what's the use case of modifying lower layer
> > > > > with an existing upper. Is it fair to say, no don't recreate/modify
> > > > > lower layers and use with existing upper.
> > > > >
> > > >
> > > > It's fine by me to document that this is not supported.
> > >
> > > ... which is scary.
> > > Note I do *not* need to modify lower on-the-fly, when I
> > > swap systems, that will happen at reboot.
> >
> > Don't be scared :-)
> > Your reaction is a good answer to Vivek's question above -
> > No, it is not fair to say don't re-create lower and use existing upper
>
> This seems like a wrong use case to me. So in above example, say
> following happens.
>
> - Mount overlay
> - modify sshd_config (it gets copied up).
> - Lower squahsfs gets updated and /etc/sshd/sshd_config gets updated.
> - Mount overlay and user now sees old copied up sshd_config. (If it
>   works).
>
> Conceptually it is not making much sense to me. What's the point of
> upgrading lower because after mounting overlay you might still see
> old file. And to make it worse, behavior is underministic beacuse
> if file has not been copied up, you will see new file.
>

That is exactly the case with package managers that update system
files, except package managers can prompt user to resolve conflicts.

Think of this is a package manager that manages a single package
called "system". If that package manager (usually called firmware upgrade)
wanted to, it could compare for every upper file to origin from system image A
and to same path from system image B before making the upgrade and
prompt the user to resolve the conflict just like a regular package manager.

But if said package manager does not resolve conflicts it is the same as
a package manager configured to auto resolve conflicts by choosing the
local modification. Not perfect, but people do live with such setups even
without overlayfs.

Thanks,
Amir.
