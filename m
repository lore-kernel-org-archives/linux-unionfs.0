Return-Path: <SRS0=LI0E=CL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21285C433E6
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Sep 2020 03:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA92E20758
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Sep 2020 03:34:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkTgdokg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgIBDeZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 23:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgIBDeZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 23:34:25 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD20C061244
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 20:34:24 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b17so3763344ilh.4
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Sep 2020 20:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qbp/jY6KbklKPX0DiYIfRCWcQkLge7W+DewaqbBNdKw=;
        b=RkTgdokgJBCnTtI5/unku8cRHIGQpcFsSMSMnBZIvNc3UJS1uLKflL3Xe5brfopuQ1
         Udd0M6MvvZaG7G3ghRRxOCb5Xmtn9QLVigAfzt0TLmWrvmBtZs3cCxmesGAkFZmenSmv
         LnMxlnpOZn46qh83PtKx7X+FlwUzY1DaEf6Da2LuPc6JUmP1PiUxZK9Sh7i8shc5Sb5a
         FWf8R8Dfp4CM0QIIyFMCYr2lB6QHzGh9rmTP/UsnOCCEBM1HW+h/ipkMlgx15KlnVbaq
         yqjEOR+iPQoq6yWs9/qE9NMlF5FdOkKR5QGQEV6iCjgKcIDKqEPc4zJDErO/uoTULYKF
         aCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qbp/jY6KbklKPX0DiYIfRCWcQkLge7W+DewaqbBNdKw=;
        b=JYSyBbqQhyDG5lalPfLzbE7fmxgsTeaSQ/wXaHkei2T9yEbeTNU/WJnprjCFTrKhhm
         dV+kp3Z0jwZgXuhOJEhX26JGL5l8F3Zk+G8TAwKOOpcrkEn1FRYgblAAKIVQtZlaopMa
         EbQvwp03Clp2sU4HgN/nxcCJ+9MRTp0FhMT1tf5LMPzgPwJmdi8bcCNTxIePSIZBQazp
         levqgwVSzz+d7b2L91xHnAK0hiFMv1zFInyMnShZ4XV7WZ82RU5AdH+mgFG4t7k5NDoV
         AUYvVZEhGNMQjDPM7fEEq5P1bgudhNEuOy26hPE0eTqCmyNnmuAPDoRECQQ6kPjay2+s
         whVw==
X-Gm-Message-State: AOAM532/CbaCAh+Bv4SBbBNaMD1booMOEqMLnMsc2UNBtQmDi2VOtIsD
        Bzs+mxM2Hkw9dFBXsq4ApOqfxfEuch0ChoYuBzM=
X-Google-Smtp-Source: ABdhPJz2DlFCiit7WncBeJfflj9s+rK1CYhSaWbP6xm2U0Vg2Z+8mbO6xbo6RiPMq7p7mhsblssCD/ne2XfLVyjBhSI=
X-Received: by 2002:a92:2605:: with SMTP id n5mr1968027ile.275.1599017663615;
 Tue, 01 Sep 2020 20:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com> <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it>
In-Reply-To: <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 2 Sep 2020 06:34:12 +0300
Message-ID: <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
Subject: Re: Frequent errors with OverlayFS on root
To:     Mauro Condarelli <mc5686@mclink.it>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 2, 2020 at 2:37 AM Mauro Condarelli <mc5686@mclink.it> wrote:
>
> Thanks Amir,
> comments inline below
>
> Regards
> Mauro
>
> On 9/1/20 8:43 PM, Amir Goldstein wrote:
>
> On Tue, Sep 1, 2020 at 9:01 PM Mauro Condarelli <mc5686@mclink.it> wrote:
>
> Hi,
> most likely this is not the right place to ask, please redirect me as needed.
>
> I'm trying to use OverlayFS to add (limited) write capability to a ReadOnly
> rootfs (SquashFS)
>
> Essentially (actual script is more complex, of course) boot-sequence includes:
>
> # /dev/mmcblk0p5: ext4 (upper+work+nwwroot+newroot/oldroot)
> # /dev/mmcblk0p6: SquashFS mounted on /
> mount /dev/mmcblk0p5 /overlay
> mount -t overlay overlay -o lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work  /overlay/newroot
> cd /overlay/newroot
> pivot_root . oldroot
> mount --move oldroot/dev /dev
> mount --move oldroot/proc /proc
>
> This works as expected, but, too often for comfort, some file
> (and sometime also directories) become unavailable due to error:
>
> overlayfs: invalid origin (ssh/sshd_config, ftype=8000, origin ftype=4000).
>
> File name changes, of course, but rest is fairly constant.
>
> This always happens when some file is written.
> Error persists reboots.
> Only way I found to "cure" the system is to go on "upper" and delete the file
> thus going back to "lower" version (in this case I should delete "/oldroot/overlay/upper/etc/ssh/sshd_config")
>
> This is a self-built kernel (Linux vocore 5.7.0 #2 PREEMPT Mon Aug 3 09:19:06 CEST 2020 mips GNU/Linux)
> on a custom target based on a SoC (MT7628).
>
> I am available to do any required test, but I have no idea about where to start.
>
> Any hint (or redirect) would be greatly appreciated.
>
> This is probably your problem:
> https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
>
> It surely looks like it is.
> I tried to follow the thread, but I'm unsure i grokked it .
>
> I am using OverlayFS (ext4 over a SquashFS) on rootfs in order to
> be able to update the whole system (changing SquashFS) while
> retaining customization (essentially tweaks in /etc/, host certificates
> and similar stuff) in an embedded target.
>
> To complicate matters I also have a dual system for fallback in case
> of faulty upgrade; this means I can switch from:
>   lower=part6, upper=part5, update will go into part7
> to
>   lower=part7, upper=part5, update will go into part6
>
> I don't need nfs at all, so exporting OverlayFS is not an issue,
> but it's unclear to me if this "lower swapping" is
> actually supported as I see:
>
> > > /me is again wondering what's the use case of modifying lower layer
> > > with an existing upper. Is it fair to say, no don't recreate/modify
> > > lower layers and use with existing upper.
> > >
> >
> > It's fine by me to document that this is not supported.
>
> ... which is scary.
> Note I do *not* need to modify lower on-the-fly, when I
> swap systems, that will happen at reboot.

Don't be scared :-)
Your reaction is a good answer to Vivek's question above -
No, it is not fair to say don't re-create lower and use existing upper

But we may decide this is forbidden in case user opts-in to
new features. The mentioned fix commit fixes the regression
for mounts without mount options (index, xino, metacopy),
just like your use case.

>
> If it is, it should be solved by commit a888db310195
> ovl: fix regression with re-formatted lower squashfs
> in upstream kernel v5.9-rc1 or in stable kernel >= 5.7.10.
>
> I'm currently at kernel v5.7.0, but upgrading to
> stable v5.8.5 shouldn't be a problem (I would like
> to avoid Release Candidate kernels, if possible).
>
> Can You confirm v5.8.+ is supposed to work in my
> use case?

Yes, it was fixed in v5.8.0 (and not in v5.9-rc1 as I wrote).

Thanks,
Amir.
