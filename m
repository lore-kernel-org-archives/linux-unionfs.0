Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1506DCDB465
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Oct 2023 19:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjJNTUG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 15:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjJNTUG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 14 Oct 2023 15:20:06 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C0BBF
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 12:20:04 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-3b2b1b03074so1117787b6e.1
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 12:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697311203; x=1697916003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNpTKrC3+Fsor5yT8ABMh5y+ddVKEPyosZr4gpJb5vY=;
        b=BFbL13oNQ7BstpJgFAH/vd0Rgl+GGFPK2Ax3ISGsC124tdgm0B1e51EKJkOsu3ltMD
         mcADCimZa7NgyshWEdDTvAbUERaF4HcQ+7EHVb7TJUXssbuEBmjQM97Au0ZN9IjlPQa3
         A7be+Lvk6y4eoCPZLEyCB9ky4RHOJxVyfbjUuxaQjpXG+mApRkXGHOLunrd7iiuYrXJ/
         I8In6ZAViR7Qj7AgEkXCpsBhfEUEBr/7yErglxV4hJKKoVTyEyVxI7+VmmSfmWQQ8/5n
         i5QzmaFiBzhoml5Un/0G8SABPQFAmCQUocZYJ1DMvWNtCuB0Hl2EQy6cW4fuhJonBo6G
         gwZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697311203; x=1697916003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNpTKrC3+Fsor5yT8ABMh5y+ddVKEPyosZr4gpJb5vY=;
        b=S9Zp2TzbidRa3ShulpGA5vAAwwQ2MWKjf7SWv7GjHpx0jBSWvYJTbjF0xxJ6nFHKET
         k59KesnV18/gzDg6z8XMZR7pZyp7/j8IvNeSftL1A9V87/tBe/No4wzO8ht/QE09g1Rl
         ADSyfvkB2hssGuM4r07t3wFXwfhr+RuYfVzEjtf2W3BN5H/Nrbx7ycgMOfKbp21asB7P
         Wn7wMsNU+urZRsBXQAPdaDf0t9v3aLkMh4BKVaIOSKpoX699+cb5sAoD8lxU5u2PYlFm
         jxk/Q1eAtnoKWckhNmS9XdN4oB1ezfktZPjSiOPCE260HY2ClhSWu8fs9qHULgn62BYX
         SySQ==
X-Gm-Message-State: AOJu0YwX2b52cOlU3YplBHXFSGeL7g+hkat5XA7hVU8Ukut/Mgiw93Hz
        N75U8EdflMwVbBqMnqOdAki8V1eSlV88cSltIHM=
X-Google-Smtp-Source: AGHT+IHbEAyTo95ucFBTpunI/EHM/m27aDExE9PJZrVT8oXGvCiQk9p80cWTg0q6kvSLcXxYQ06UKetRb+umj978UdA=
X-Received: by 2002:a05:6808:cd:b0:3a8:7c67:7cd with SMTP id
 t13-20020a05680800cd00b003a87c6707cdmr31447660oic.24.1697311203593; Sat, 14
 Oct 2023 12:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
 <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com> <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
In-Reply-To: <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 14 Oct 2023 22:19:52 +0300
Message-ID: <CAOQ4uxien0Pn4-h8zsMUyX6ZCURrdSkTJ8GkO7_dD8QFU2E4Qw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Oct 14, 2023 at 9:20=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Sat, 14 Oct 2023 at 19:31, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > If you can code this up quickly, that's good.  I can have a go at it
> > on Monday, but my PoC patch needs splitting up and so it's not ready
> > for 6.6.
>
> Attaching my current patch (against your 3 patches).
>

That's a nice patch, but it's quite big for rc6 ;-)

I'll just go ahead and write a patch for ovl-fixes to disallow the ':' pref=
ix
and we can get your patch into shape for 6.7.
I plan to send ovl-fixes to Linus tomorrow.

Thanks,
Amir.
