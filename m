Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB925C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 30 Nov 2021 15:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbhK3Ppn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 30 Nov 2021 10:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242727AbhK3Ppe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Nov 2021 10:45:34 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B636C061574
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Nov 2021 07:42:15 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id p37so42263207uae.8
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Nov 2021 07:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3he07kZnl0IvpW1ttLcBOH+a2Io61iVAqWD/f/1h1kI=;
        b=4BWKRPXXKUFCrOOQJ4WgdwnogD9KR2ieJEQgMQh9OW/h3w1lYiZAaLLbmNH8ye8rgZ
         vzyuVVy66ajSdB0ZDuSlrZUsqutmXapVowdYKhe1BUXwhuGl6EXIREmeXTK3x8D33AdS
         OulpUvUHPyB9oDq6zGlojMVnmxLLYCdiljvx57xnclPH2s6VsHGoom5qF9yYF1xNi/Zx
         pWJFfzFJFJtY2BBrONuPAJtSE76LdSC6qaQij7JVn47R67RmpiIt0Xns+vLqAiiq3+Zd
         oM1XtUSvUSSyImSmoemep7HIFaJBi5ECXDEPsGl6wmmMJC47SidbFVvUUKOz/32MKNEm
         caYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3he07kZnl0IvpW1ttLcBOH+a2Io61iVAqWD/f/1h1kI=;
        b=Xgr81Cmq0zA1COPvwU1AR2sOdc2/GrzxY0UQxr+9akbPYx8DPHM2HjvgKULE0yEZ49
         kiniv2IuSmZhXV2ytx3S81w4T4ChDPriVu7CoLNJu1oIIA/WKZhlya1sPPPQTb+o8V0z
         zEn+9GHO3sA/3Ve3zqV4MT+iyhMrlkU6mjPOsLDmMm2nLdD9lKv9KjRi6H9pqkwPRJbI
         PXsbjupmVQkYMmKfiaONd0CyKZ6ffUV5BUpVABG4D6ge61JYMvoWusGFypDUPKO2r0pL
         jtVmXOKVFyQHvObmAVs2Zwr60Yj/N5SmR+RkuOI+CXBSNSL5WLY3E8Xytk974pDZzd2v
         hmdQ==
X-Gm-Message-State: AOAM530kN0m8O/8k2soYozfvWa/u7XtuMFFOGfdgO9mbA21ForcwjcOW
        z8oRttBT8VyoTwbSPGSH6Rz8znTEKrYMlY9NZAB71ZMo7cY=
X-Google-Smtp-Source: ABdhPJwUqN8NFHHrMvlp1+wAX5QwLuwSo4BR6xeXUhuVesuVXKDibpspQk+zwPuTtLxZtFZ5sFgOZ6VUCxNIQeUN1X8=
X-Received: by 2002:a05:6102:6c9:: with SMTP id m9mr41731391vsg.32.1638286934647;
 Tue, 30 Nov 2021 07:42:14 -0800 (PST)
MIME-Version: 1.0
References: <CADmzSSh7P+T78nuKxgK4mjOMMPO6AZmtYBFw+uu4UuE_K5FWCA@mail.gmail.com>
 <CAOQ4uxjPMHnS3zU11t_Jo5OXAv4-vXj4+9BtAxMUt0ueTFgmtQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjPMHnS3zU11t_Jo5OXAv4-vXj4+9BtAxMUt0ueTFgmtQ@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Tue, 30 Nov 2021 07:41:47 -0800
Message-ID: <CADmzSSgjHs2Hk_OLrgBKt5LQZ5hJjmC8Q_ATw+mwYq1SZLbndg@mail.gmail.com>
Subject: Re: index=on,nfs_export=on Operation not permitted
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

this worked fine on buster
mount -t overlay overlay -o index=on,nfs_export=on,\

On bullseye I got the error: Operation not permitted
remov index=on, no error.

The rname/error did not cause anything to appear in dmesg.

giving it a bit more thought, I suspect there is a bug in bullseye:
index=on triggered the error.

I'll try to recreate this shortly after Dec 12.

On Tue, Nov 30, 2021 at 7:19 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Nov 30, 2021 at 4:54 PM Carl Karsten <carl@nextdayvideo.com> wrote:
> >
> > I don't need any help, This seems odd enough to report.
> >
> > I accidentally  built my nfs server on buster, which threw some errors
> > about index=on, so I added index=on.  Then I rebuilt the server on
> > bullseye, and almost everything was the same, except for 1 little
> > thing.  I removed the index=on, and all was well again.
> >
> > server:
> > dist=bullseye
> > d=/srv/nfs/rpi/${dist}
> > p=${d}/boot
> > rm -rf ${p}/work/index
> > mount -t overlay overlay -o index=on,nfs_export=on,\
> > lowerdir=${p}/setup:${p}/base,\
> > upperdir=${p}/updates,\
> > workdir=${p}/work \
> >     ${p}/merged
> >
> > /etc/exports
> > /srv/nfs/rpi/bullseye/boot/merged
> > *(rw,sync,no_subtree_check,no_root_squash,fsid=1)
> >
> >
> > client:
> > root@raspberrypi:~# mount
> > 10.21.0.1:/srv/nfs/rpi/bullseye/root/merged on / type nfs
> > (rw,relatime,vers=3,rsize=4096,wsize=4096,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.21.0.1,mountvers=3,mountproto=tcp,local_lock=all,addr=10.21.0.1)
> >
> > root@raspberrypi:~# mv /boot/z /boot/config.txt
> > mv: cannot move '/boot/z' to '/boot/config.txt': Operation not permitted
> >
> > root@raspberrypi:~# strace mv /boot/z /boot/config.txt
>
> strace is not useful information.
> kernel log would have been able to shed more light on the error.
>
> But I did not understand the report.
> The error was on buster/bullseye? with index=on? without index=on?
> You managed to confuse me.
> index=on is deferred from nfs_export=on since commit
> b0def88d807f ovl: resolve more conflicting mount options
>
> So that is probably the difference between buster/bullseye.
> Didn't check which kernels they use.
>
> Thanks,
> Amir.



-- 
Carl K
