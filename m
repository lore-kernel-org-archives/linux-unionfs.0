Return-Path: <SRS0=37bb=CM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97855C433E2
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 08:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E86205F4
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 08:30:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qdkIXpf2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgICIac (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgICIa3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Sep 2020 04:30:29 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A12FC061244
        for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2020 01:30:29 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so1779281iln.1
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Sep 2020 01:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjJYsVExZXGI21E17cXkbhPweZQdcPrrDOboEm3AaDs=;
        b=qdkIXpf2x9rrZ3JPNmxm6eIluwxxhtjLuZEyaOr0zR8r0xAMcJixeGR3YHpHGHB2qG
         fbi4GiKiTZ4fXgCbOikfTfS/HWUT8LqlPyhM7JEu1JcPaiiRDiiJmZDfrx53c6BzlVqV
         MRbqS2lT3tzBIdqL8T3YEK9R602fxE8KshFTWdA/7oKy4pjhJ8kXkbUsLmQakiPTq0q7
         h+PZsKIE9+2D/R2zIwTT2GaJ3sX2rxIQotmT6PegD2cZmL5tEz/zUPxv/ba/YD36rS8V
         fN2UolQKkxQvqiX7ShgQAEjfLuu9bB3obkV7KvcE4kUct74qKGMZA7sPXiouLN2YMS+x
         IAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjJYsVExZXGI21E17cXkbhPweZQdcPrrDOboEm3AaDs=;
        b=K9OsurbWX5Rt9sLfwoCP1nk2HDAQuQudOoa/OmEGSzEBt4XIjlkmVKZAvPtMnf22tn
         o4koj80ZKFCy3/Gk22Iit85Psn/hCb53ktneErtMP7ojMPBcMZP70QpHF9oREq0P2dcP
         Gy7jh9b7dOu5Hx3HRP+nnXBh98Zhfl+QV/z8wPs/sqtG5jWRrRXiIE27qL7aeM7LomG5
         UdDRN5r5ilkegxZ2o4yMyjTqpnxpg/NGfZ+e8HnREGmQ5tVPluJFck2e5k3cLX/wGeZY
         68WmR0nZPphuor+cz5SfH5uGXZsHAeIDZl3m8HaCmun5H1aQUYJzAcMOdvkyitvRwQSf
         AdaA==
X-Gm-Message-State: AOAM533/d6d7OfQPlMNOk3f4Z/+6VqKexcLcW1OsPb/4GdTlzEx0q0EA
        EbDYNv+M7Nvj7RvlKlYPQg0BDnEbsFqPp50MkEM=
X-Google-Smtp-Source: ABdhPJx4Ro1FEY8zfw9Wge1dNXqFqlbDAdOl1a7OsVSk7jbMyc0rz7pKsuioz/S4mjWJDKKNGWwni5sp/XWYh4V5xVE=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr2240007ilf.250.1599121825698;
 Thu, 03 Sep 2020 01:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it> <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
 <20200902132921.GA1263242@redhat.com> <7862cfc2-03e1-61b8-ae36-96ef5d28915e@mclink.it>
 <20200902202048.GD1263242@redhat.com> <8a5fb512-e430-40c1-2266-e90625385e62@mclink.it>
In-Reply-To: <8a5fb512-e430-40c1-2266-e90625385e62@mclink.it>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 3 Sep 2020 11:30:13 +0300
Message-ID: <CAOQ4uxg9p2w-z9c+WzVjr5CO3xmf2gqK-VrhhUOcbA2uQJiseA@mail.gmail.com>
Subject: Re: Frequent errors with OverlayFS on root
To:     Mauro Condarelli <mc5686@mclink.it>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Mark Salyzyn <salyzyn@android.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > So basically squashfs image will be udpated. I am not sure how this
> > will work for all the cases. What if application is updated and
> > it decides to rename its config file from foo.txt to bar.txt. Now
> > when application is launched, user defaults are lost anyway.
> I'm in a somewhat middle position.
>
> Targets are embedded systems and it wouldn't make any sense
> to implement a fully flexible update system (deb/rpm/ipkg/...);
> I just have two "packages": system and application.
>
> I *am* the "rootfs (aka: system) image provider".
>

FYI, I am not a stakeholder. Just chose the "defending" side, to counter
Vivek's opinion for the sake of the argument.

FYI2, overlayfs maintainer as well as Linux maintainer have always
followed the practice of not breaking existing user workloads, so the
status quo is playing to your side anyway.

I assume, although you did not mention this, that you maintain an
OpenWRT derivative.

Just so you know, Android is another "system image provider" project
whose developers were talking about using overlayfs to provide
"debug mode", wherein developers can modify system files.
This is the use case for the proposed override_creds=off feature [1].

I do not know if this mode was deployed on existing phones, but anyway,
it is not enabled in production mode, so it limits very much the problem
of conflict resolution.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20191104215253.141818-1-salyzyn@android.com/
