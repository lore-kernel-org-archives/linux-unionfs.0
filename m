Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAB8C432BE
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 21:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BC860EE7
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 21:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhHIV1f (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 17:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbhHIV1e (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Aug 2021 17:27:34 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9125C061796
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Aug 2021 14:27:13 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id l4so11041957ljq.4
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Aug 2021 14:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jggCUuylUTp8Qazkw4vyHQk7Sx27WnHOaFstAIevKbw=;
        b=ahusbhrQOwPDpp9d7umFODX39riwpah9xsJFNwdPYjW/4+UDVTFy/QrRYOBOclHXAu
         UHM/hA3SaIXz8Vcb8Cfiy84Yqm/VgSkEy88uT4fFKLuWgcfwrFLk5f0x7mzSBcZgc1uu
         Xb+wv2gYe2MI+DuWdQnYwvY8TTDG7CPECRQHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jggCUuylUTp8Qazkw4vyHQk7Sx27WnHOaFstAIevKbw=;
        b=hp0smO2HbcMguk/JymVpPmwZXzGwGDX+0Fob/7M07gr8VqgsWSI1CcWMD6ejtcN5nA
         UCyoHKkjOWWQ538iYHMWWWD9Jp0I5lyTuxYKYhehYLztyoYKZeoFd4NUlcC74DvpdhHI
         URcHO051HPJH25RP6euYCIbslN+aKmpXxaUyIZBEWrILE0LEIzJm0HcU5TXvhdUKXP2l
         BeDBu/JjltroYhDb4U92oRKaLgmNVp0j+CJMfsZxC80LPxG44EKaO0RyVjP08gXQddH2
         Dy8Du0sChD07bhLpsqaHbwfjC2Eutwx1MkZLuQtWiHNayf/y4tNtNJdWnTAwygukpG65
         Zwmw==
X-Gm-Message-State: AOAM531psZahEy/al4m8kkf9Ce+/XDUSjMirhBjzA7ARozXBxyyhBJL/
        iTv+XqTQ/o2nUtZbC3zsRlOw0pFByzIH6TIs
X-Google-Smtp-Source: ABdhPJxbsv1WsP54i5Abf8atTAh4XU7WYUdHp1lO+OyqrgcpEprLgPeTNHtMu/wV6jzODRDEEn20Aw==
X-Received: by 2002:a2e:b60d:: with SMTP id r13mr617921ljn.218.1628544432036;
        Mon, 09 Aug 2021 14:27:12 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id z1sm1842219lfu.222.2021.08.09.14.27.11
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 14:27:11 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id h11so10645639ljo.12
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Aug 2021 14:27:11 -0700 (PDT)
X-Received: by 2002:a2e:80cb:: with SMTP id r11mr3942175ljg.48.1628544431464;
 Mon, 09 Aug 2021 14:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <YRFfGk5lHL0W27oU@miu.piliscsaba.redhat.com> <CAHk-=wigKQqEqt9ev_1k5b_DwFGp7JmCdCR1xFSJjOyisEJ61A@mail.gmail.com>
In-Reply-To: <CAHk-=wigKQqEqt9ev_1k5b_DwFGp7JmCdCR1xFSJjOyisEJ61A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 9 Aug 2021 14:26:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjhm9CV+sLiA9wWUJS2mQ1ZUcbr1B_jm7Wv8fJdGJbVYA@mail.gmail.com>
Message-ID: <CAHk-=wjhm9CV+sLiA9wWUJS2mQ1ZUcbr1B_jm7Wv8fJdGJbVYA@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs fixes for 5.14-rc6
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 9, 2021 at 2:25 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I've pulled this,

Actually, I take that back.

None of those things have been in linux-next either, and considering
my worries about it, I want to see more actual testing of this.

                Linus
