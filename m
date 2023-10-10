Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AD6CD8CAE
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Oct 2023 18:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343545AbjJJSdT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343593AbjJJSdS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2023 14:33:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7C5B9
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 11:33:16 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-533c5d10dc7so10583792a12.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 11:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1696962795; x=1697567595; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W52UCgDK21Sr3Uc5N6Be2TLldqXBJHgoQde1trpFCRc=;
        b=Q/eOQF1MNXEUQT9XvtfoqQAE1+BMa3fahtmgs15B/EJHamqUoo8nigeZu2sGuRJG4d
         Vow6mc0la0OJmeziGJ5/Xxf6GuyT2pOKnB+CqDAsuvDLSdzwbT1urG1ydL6gXjTb69Ke
         AwqDFYwtUj1/LiA5s9CRJkKaAXODY/XK1jPII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696962795; x=1697567595;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W52UCgDK21Sr3Uc5N6Be2TLldqXBJHgoQde1trpFCRc=;
        b=bXfogJNHgvzk9gx9b6uK/YEoSrv/byqsTH3rckSyfCpx1h0T/NcyjmqOcgrdfIBHGV
         ZQ0nFSQ26E6uewLaetJm0fRtaP6COPJKes6hvy8iIruTnkgj81b4C3yDdIAPSpYRBCP1
         NQgMWpPO7OgAM7UwVMtTaera+xN3BlqoarIwetp47mak1Av7Aj5Gz+bHyQcachZNErbP
         uMQ0vuECM+bB5g49RaZzQ5U+5cgv06/1mStHSv/URMBFDmlyVre/IHBLKg1rvx2/6T8S
         xcGiI71cT6Spht65LfCqPNjGWPtDH0jjJ6I8KWE25eAnIAnZm1Erog9ioKsGsAq/YeRL
         n5Bw==
X-Gm-Message-State: AOJu0Yw/O2L+ns/yjqxn7l1ksBUCkaGopO4nWBp71D04Q5/IU/zPp9lW
        y16YtqdfEpt8SzdQ7C5ac9UmaL7YKaPZB/CJht067A==
X-Google-Smtp-Source: AGHT+IE6ZH4+IatuKNtD3ALtUEmmkIXcSPcNXBOmlbQ8w3RPc3qrSzEBZ6zBU6JLAa0gKWCr6ns9nQkjCPK2dOgOQmM=
X-Received: by 2002:a17:906:53ce:b0:9a1:f5b1:c864 with SMTP id
 p14-20020a17090653ce00b009a1f5b1c864mr18162728ejo.10.1696962795232; Tue, 10
 Oct 2023 11:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com> <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 10 Oct 2023 20:33:03 +0200
Message-ID: <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 10 Oct 2023 at 20:15, Amir Goldstein <amir73il@gmail.com> wrote:

> It may not be me, it may be someone else, so there is a limit to my
> commitment, but kernel developers usually abide by Linus' no regressions
> rules (which do allow some slack).

Note: the no regressions rule is about actual "out in the field"
regressions, not about potential or theoretical regressions.

My guess is that changing the escaping rules for workdir and upperdir
would not make any difference.  Look: on my laptop 0.0032% of
filenames contain a backslash.  How likely is such a filename to be
used as workdir or upperdir?  So yes, I think getting rid of
unescaping for these parameters on the new API is safe and will not
invoke the no regressions rule.

The same cannot be said of lowerdir, because the incidence of colons
in filenames is much higher.  But the new API also introduced an
"append mode" for lowerdirs, where the colon doesn't have the same
separator role as with the "bulk mode".   Unfortunately it's not
possible to clearly differentiate the two modes, which I think is a
downside of the current design, and it's why I suggested the _noesc
variants.

>
> Anyway, let's focus on what you would like best.
> If you prefer to just fix the regression, it is doable.
> If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think we can
> find a volunteer to write it up.

It's not all good: when showing these options, the result is
completely meaningless.   Or is there a plan to make that work nicely?

THanks,
Miklos
