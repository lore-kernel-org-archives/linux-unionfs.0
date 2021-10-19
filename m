Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFC9C43219
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Oct 2021 15:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB5EE61074
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Oct 2021 15:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhJSPbs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbhJSPbo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Oct 2021 11:31:44 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0394C061749
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 08:29:31 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id h19so647785uax.5
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 08:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BcKrpzY1X8RM4Hd4EywBeexmRy7XTKEtN/URGefCme8=;
        b=MU/kv1zIIO41rET5PfvD403WnyTdPPxI7JQOQXTRpevA6iR6+cJdk0zSsYLnrv0qc+
         erBfwKZIHk8j948UWlkxFqVpdklPscsQMZkYduBMpHQWb8aeXdqmHrKmwDIjWpnvKI2K
         7hiCHcbsI8NHUp+/DRpCCAYqTqiofYOtaTkx8q2j9dMid1vLvT959/QGqqN5YXG8GL36
         ika5IB2wmj8BJn+81gBn4yWIum2Mfl/jed+UKatFW43PSY33yNTy/dayeXbdWczYJMFY
         6siCFJMId2tF0DopNqg6jiHi9C04DBdxb+iuavuwOJoVMjGNwnuEKsEuApWY1ZEaeKpD
         dPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BcKrpzY1X8RM4Hd4EywBeexmRy7XTKEtN/URGefCme8=;
        b=ezM1TViGCXK6kwU0dbZzVDXO4Ywfa/QJqId/nmBmcyfWZ6iWjKwdY29qVGFrXFOEWR
         hbB2WPtK8SGPtnFojDw7SChYaXkzyCLqDObaWD2m62EupEK9KpkcMXvbO02NlW9zM5Ig
         SiRXR+fQa7l1HJmTHkcn0A/rX7oGF3xLGuawZCH6lNDQfyzm58hfgILhH8zaamYYee3k
         GdaSseyNOA+Av6WyE/oc/+oNf2p8hK+SVw5v2qNT4wnkxlECwcA8EV01cREGL9wCMpFR
         EKy3DdQ92E2sPpj2ulJFKsGfm/O+rFvVReP+a6M8ZYOQNswHu8rtUwKBGSfKgQqRFRO7
         E8bw==
X-Gm-Message-State: AOAM533oDcu3+pDKvpxKAtOBthSp9coo8BIsGjZKKZPJtMQF3GxOErMt
        GG2IOSJHmTTWJTfLI0BzML3hQcgyeFdh+QxaJ6Y=
X-Google-Smtp-Source: ABdhPJyb3Wmkq2j1Y05/ZCU2Fr9HTRKsuwmAb4FuDDP2vOftsqv6kuUX9ZOzw/PcxChAoD6hHslQ7VeEQKpZsxp0mvk=
X-Received: by 2002:a05:6102:304e:: with SMTP id w14mr23993333vsa.52.1634657370859;
 Tue, 19 Oct 2021 08:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgquwg49GfMNSxi6KRcvq2nxPhwtiH311D+Ux_VTuE+fA@mail.gmail.com>
 <CADmzSSgZqrBCavL=NmO1_YPCHP7DfG9hLnN4gNBXZXyJTo8XiQ@mail.gmail.com> <CAOQ4uxizf9=arB8V7N_EtgsDrjO3XetKSCkQA3ErtwyovExkuA@mail.gmail.com>
In-Reply-To: <CAOQ4uxizf9=arB8V7N_EtgsDrjO3XetKSCkQA3ErtwyovExkuA@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Tue, 19 Oct 2021 10:29:04 -0500
Message-ID: <CADmzSSgMTfZyvWbbiR0Zpk8=2Db58gJfWXMU=hRwauzFqCZ+HA@mail.gmail.com>
Subject: Re: sd .img partition loop support
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

case insensitive, I can see how that would be a problem.

Now that I understand that I'll stop trying to make it work
thank you.

On Tue, Oct 19, 2021 at 1:53 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Oct 18, 2021 at 9:46 PM Carl Karsten <carl@nextdayvideo.com> wrote:
> >
> > I'm trying to overlay an empty upper dir onto a fat/loop/img fs and getting:
> >
> > juser@negk:~/boot$ sudo mount -o ro /dev/mapper/loop0p1 img
> > juser@negk:~/boot$ sudo mount -t overlay overlay
> > -olowerdir=img,upperdir=upper,workdir=work merged
> > mount: /home/juser/boot/merged: wrong fs type, bad option, bad superblock
> > on overlay, missing codepage or helper program, or other error.
> >
> > [ 2449.670177] overlayfs: filesystem on 'lower' not supported
> >
>
> fat was never supported as lower or upper layer AFAIK, see:
> https://lore.kernel.org/linux-unionfs/2527352.xHhNOModH5@nerdopolis/
>
> This is due to the case insensitive and special name encoding of fat.
> It is not unfixable, but it was never a priority for anyone to fix it.
>
> I suppose it would be easier for you to copy the image to another filesystem
> before constructing the overlay.
>
> Thanks,
> Amir.



-- 
Carl K
