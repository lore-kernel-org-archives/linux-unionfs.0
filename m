Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A737FC433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 00:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 771F5207D8
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 00:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590105667;
	bh=ikOQX/ARox4RSTZOjNFr8E5nK/ZSK77fGgdIOFbaTOc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=bIbFZZzMgWUdKKITtd6B5ZCEskzj4eejHfbWFtc8/q9ro8l6BazlODT7UvXg2unQF
	 5/+7odwBGKtL0aioWXVFXIW6tssFo5OJE003Iodlph5kmaIqrnYxQhlwIDBeoh4iM2
	 moL+jyp84XDpMGA6rrcsNNonYsQIjq+X8wDXU0L4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgEVABH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 May 2020 20:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730338AbgEVABG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 May 2020 20:01:06 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506AEC05BD43
        for <linux-unionfs@vger.kernel.org>; Thu, 21 May 2020 17:01:06 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id e125so5526862lfd.1
        for <linux-unionfs@vger.kernel.org>; Thu, 21 May 2020 17:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vbo7f9Gr3cg/KLt/kOvWotZglXfgKin96QcbEfg0Yl0=;
        b=TFdXsMqAMyMKk9ye8tn2O/u/rQLmivp7qkkUkjoGIuirsDa5u7y7VK/iAP5npzCGm4
         DrEjofrl+c2jqHiQGxbMu0kLgifgYnjy4EIk0TIi/3hnmC38lqS6wf6XraHA3KxElkdH
         rTo0K9NG6zdBb/ImWn4JBhqPb7/fqXrQNHsYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vbo7f9Gr3cg/KLt/kOvWotZglXfgKin96QcbEfg0Yl0=;
        b=ujaZRJor9bNkOKvy8UJgum9ie1SqB1ijYbNv53drJg7aqizuHYylH8Z4GIoqQUTuJc
         ds4lrfjnZZ4V/6fYoF95jDUcTNF+tmOTnIPTkFxyv2UeoHNzHlHH0nyQIaNmwWpmnpR4
         b2svbQ6xxEqX6242akWN3Rjh08vxUwBq9SjQ2KUHtF9hnIaPKNVKijzfZ/6Uo71QHhxD
         oRN4E0IyMWrcepV+0DbTrgj0pJNeT0yW6SflzyOCg1VArWjSYqSyg2Ha9HLtrgmBsLvo
         i1pMzwRL/kZMqtTHJ8oaGDezEp2dpAOOpn591enFRtEriauNxwcz0JqMJCtsTKslDGro
         N78w==
X-Gm-Message-State: AOAM531gJd6Yw7fZiiQ+ZZJmJjjQIbS84nRn6UBRX3wWrUqFhS1ccMGO
        B5Z8npB0ZDRwLB5/gzrzYt8xovICIa8=
X-Google-Smtp-Source: ABdhPJy409u3ZA2/WcfVx4X4cxbbR44zeNVOF6T2E9BjsB2ufpnxI09K6FGLf14+eSZlwuR7r27bvQ==
X-Received: by 2002:a19:c88e:: with SMTP id y136mr6319038lff.78.1590105663405;
        Thu, 21 May 2020 17:01:03 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id c69sm2077064lfg.23.2020.05.21.17.01.02
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 17:01:02 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id w10so10542891ljo.0
        for <linux-unionfs@vger.kernel.org>; Thu, 21 May 2020 17:01:02 -0700 (PDT)
X-Received: by 2002:a2e:9891:: with SMTP id b17mr4329530ljj.312.1590105661602;
 Thu, 21 May 2020 17:01:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200505154324.3226743-1-hch@lst.de> <20200507062419.GA5766@lst.de>
 <20200507144947.GJ404484@mit.edu> <20200519080459.GA26074@lst.de> <20200520032837.GA2744481@mit.edu>
In-Reply-To: <20200520032837.GA2744481@mit.edu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 21 May 2020 17:00:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgUM=bB4Ojz+km9aAtWC9TPtcNXANk32XCPm=yZ-Pi2MA@mail.gmail.com>
Message-ID: <CAHk-=wgUM=bB4Ojz+km9aAtWC9TPtcNXANk32XCPm=yZ-Pi2MA@mail.gmail.com>
Subject: Re: fix fiemap for ext4 bitmap files (+ cleanups) v3
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Christoph Hellwig <hch@lst.de>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        adilger@dilger.ca, Ritesh Harjani <riteshh@linux.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Ted's pull request got merged today, for anybody wondering..

Christoph, can you verify that everything looks good?

          Linus

On Tue, May 19, 2020 at 8:28 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> I'll send it to Linus this week; I just need to finish some testing
> and investigate a potential regression (which is probably a flaky
> test, but I just want to be sure).
