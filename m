Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C014FC61DA4
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Feb 2023 23:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBWXL7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 23 Feb 2023 18:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBWXLz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Feb 2023 18:11:55 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2A054A09
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Feb 2023 15:11:53 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f13so47641891edz.6
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Feb 2023 15:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eitmlabs-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZhcqxXFunyKmJAnTkBe/sYveKPMZiCHLdgGndCIvmw=;
        b=RPm9ajGg+bpqPeCQ1T7jJwujkrC4b1kK2z76ktAQ91JHtEA7+I+szu01tvj9rAzM/6
         YY+DVjRz2xFvARlTc6YLhn/CVGCjezw0WG0Nj9o08eMCQtsn4Ni0kQQ5hrisWocExNpl
         QQXcRsZzf84o4wLtmHyJAVsELWiYpMAwBqsm3cfAIM8uzGMuPECGV+gOy3kw5UpACdbf
         0Z/jcSjufhR8XAucuecmqwEZSK+mn9OLMordC8aoOMK3pbuKCjbqjaDq+ajY2nEi44B5
         0l0AwBlR1tI9XjcOVBg6vkqMnpys15syHbxbKQ0PE1ZWaL+cMY526C+3g3CBl5OaIf30
         aPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZhcqxXFunyKmJAnTkBe/sYveKPMZiCHLdgGndCIvmw=;
        b=Cl2SiMh2VPQnIpskq+STEHNk9kZ/D5LGGij3hCnrG65NPHQwF1/DpXn/qPg1dIZl6J
         NferqL5eEQeluPYOSX+35BgVLkphI+ozWGSAtG3bYrFGxUacIyhgLTlB7VMo3RohgrQ3
         Vy5ip982Ax/B+paVEQ596rlC6I/d4fNoQ+NJmDnX9GBBZDgFn/3Sk44uP3wSjTus6Xv4
         j3VsJtWGrqDPSdR3pbnET5PIvSjjl8VDlCfYHNacSHMQJgCtkJ3u1AzxpiTe5WZW8Uhu
         eQCno4OH05dANKyFS+QL5oxOCmUNgm5peoSPRIkf1P74MwowPYOQ83Z+vLilXug3+dz0
         2GOA==
X-Gm-Message-State: AO0yUKVjN8Bgf41BBUueehtoQUF+HpiL80lVGOLKqsCt27YeB3lCkS6d
        xlZoHEOqO19vqUNMORKo1h3gjueoCE8FMZK4JFmER4bFCbwM6nX6
X-Google-Smtp-Source: AK7set/bDMEFLOb9zD5mIiYLI3kJ4oUZ7FKxuHEIh9/zbBkhb+idLsQElu6vADg4xiN5SGB6/VWABvfcrsDnri21a74=
X-Received: by 2002:a17:906:3388:b0:8af:b63:b4ba with SMTP id
 v8-20020a170906338800b008af0b63b4bamr9918125eja.3.1677193911673; Thu, 23 Feb
 2023 15:11:51 -0800 (PST)
MIME-Version: 1.0
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com> <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com> <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
 <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com> <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
 <CAHk-=wjg+xyBwMpQwLx_QWPY7Qf8gUOVek8rXdQccukDyVmE+w@mail.gmail.com>
 <EE5E5841-3561-4530-8813-95C16A36D94A@kohlschutter.com> <CAHk-=wh5V8tQScw9Bgc8OiD0r5XmfVSCPp2OHPEf0p5T3obuZg@mail.gmail.com>
 <CAJfpeguXB9mAk=jwWQmk3rivYnaWoLrju_hq-LwtYyNXG4JOeg@mail.gmail.com>
 <CAHk-=wg+bpP5cvcaBhnmJKzTmAtgx12UhR4qzFXXb52atn9gDw@mail.gmail.com>
 <56E6CAAE-FF25-4898-8F9D-048164582E7B@kohlschutter.com> <490c5026-27bd-1126-65dd-2ec975aae94c@eitmlabs.org>
 <CAJfpegt7CMMapxD0W41n2SdwiBn8+B08vsov-iOpD=eQEiPN1w@mail.gmail.com> <CALKgVmeaPJj4e9sYP7g+v4hZ7XaHKAm6BUNz14gvaBd=sFCs9Q@mail.gmail.com>
In-Reply-To: <CALKgVmeaPJj4e9sYP7g+v4hZ7XaHKAm6BUNz14gvaBd=sFCs9Q@mail.gmail.com>
Reply-To: jonathan@eitm.org
From:   Jonathan Katz <jkatz@eitmlabs.org>
Date:   Thu, 23 Feb 2023 15:11:35 -0800
Message-ID: <CALKgVmdqircMjn+iEuta5a7v5rROmYGXmQ0VJtzcCQnZYbJX6w@mail.gmail.com>
Subject: Re: [PATCH] [REGRESSION] ovl: Handle ENOSYS when fileattr support is
 missing in lower/upper fs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     =?UTF-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi all,

Problem persists with me with 6.2.0
# mainline --install-latest
# reboot

# uname -r
6.2.0-060200-generic


Representative log messages when mounting:
Feb 23 22:50:43 instance-20220314-1510-fileserver-for-overlay kernel:
[   44.641683] overlayfs: null uuid detected in lower fs '/', falling
back to xino=off,index=off,nfs_export=off.



Representative log messages when accessing files:
eb 23 23:06:31 instance-20220314-1510-fileserver-for-overlay kernel: [
 992.505357] overlayfs: failed to retrieve lower fileattr (8020
MeOHH2O RecoverySample2-20221219-A-JJL-WebinarHilic10C-TOF-TT54-Neg-1722.d/Storage.mcf_idx,
err=-38)
Feb 23 23:06:32 instance-20220314-1510-fileserver-for-overlay kernel:
[  993.523712] overlayfs: failed to retrieve lower fileattr (8020
MeOHH2O RecoverySample2-20221219-A-JJL-WebinarHilic10C-TOF-TT54-Neg-1722.d/Storage.mcf_idx,
err=-38)


On Mon, Jan 30, 2023 at 11:27 AM Jonathan Katz <jkatz@eitmlabs.org> wrote:
>
> On Thu, Jan 26, 2023 at 5:26 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, 18 Jan 2023 at 04:41, Jonathan Katz <jkatz@eitmlabs.org> wrote:
> >
> > > I believe that I am still having issues occur within Ubuntu 22.10 with
> > > the 5.19 version of the kernel that might be associated with this
> > > discussion.  I apologize up front for any faux pas I make in writing
> > > this email.
> >
> > No need to apologize.   The fix in question went into v6.0 of the
> > upstream kernel.  So apparently it's still missing from the distro you
> > are using.
>
> Thank you for the reply! ---  I have upgraded the Kernel and it still
> seems to be throwing errors.  Details follow:
>
> Distro: Ubuntu 22.10.
> Upgraded kernel using mainline (mainline --install-latest)
>
> # uname -a
> Linux instance-20220314-1510-fileserver-for-overlay
> 6.1.8-060108-generic #202301240742 SMP PREEMPT_DYNAMIC Tue Jan 24
> 08:13:53 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
>
> On mount I still get the following notice in syslog (representative):
> Jan 30 19:11:46 instance-20220314-1510-fileserver-for-overlay kernel:
> [   71.613334] overlayfs: null uuid detected in lower fs '/', falling
> back to xino=off,index=off,nfs_export=off.
>
> And on access (via samba) I still see the following errors in the
> syslog (representative):
> Jan 30 19:19:34 instance-20220314-1510-fileserver-for-overlay kernel:
> [  539.181858] overlayfs: failed to retrieve lower fileattr (8020
> MeOHH2O RecoverySample2-20221219-A-JJL-WebinarHilic10C-TOF-TT54-Neg-1722.d/Storage.mcf_idx,
> err=-38)
>
> And on the Windows client, the software still fails with the same symptomology.
>
>
>
>
> >
> > > An example error from our syslog:
> > >
> > > kernel: [2702258.538549] overlayfs: failed to retrieve lower fileattr
> > > (8020 MeOHH2O
> > > RecoverySample2-20221219-A-JJL-WebinarHilic10C-TOF-TT54-Neg-1722.d/analysis.tsf,
> > > err=-38)
> >
> > Yep, looks like the same bug.
> >
> > Thanks,
> > Miklos
