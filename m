Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101D6C77B7A
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbjFFJaV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbjFFJaU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 05:30:20 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4710E6A
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:18 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-974f4897d87so622185866b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2023 02:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686043817; x=1688635817;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/b9eQD2U4JFecRonfIOzNQ915xdjwedMzqOKJvtv8I4=;
        b=OPfRD0ynWhQCsls7kIyUJwC/5VMb2UedOuW6bR2T+RBZUlwH55rkw0kEiJygNo4IiQ
         8QbTl+DwEnm7UUc3V5BFhyoWygd+nwyqnfrQ9sU7+JnaPoIDCE5ZFW+membQA72UFPGI
         wE/+tfiDDy6dAsvpUJJ7Riw5DjtmuloxWJ4Bg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686043817; x=1688635817;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/b9eQD2U4JFecRonfIOzNQ915xdjwedMzqOKJvtv8I4=;
        b=lAIDWH0C4BnqnDA1bRa2XFeExN+NGDWTdx4Hb2TvxVD8dDw9r78hCAhs/vN4zsM/zs
         QQxGuxg0+cTjnLyENUaQ76CSFxCvhFnNDVcBuIhtp3jUFZDLAVawsgDpQIXZ0IZxeDWB
         VP+TGoZ5f7O0fjqsKoUzOj201+GgvU5qoXJZ7vApqfx1s5ztE7dSX71/FNsvZ2LOnSMl
         bL0vLNCOF5G2pp+9O3Ab/vKZwfq0TL83VRNfU0KfVzHajl0WSjEqMWA5i/uO65Hl+fQo
         OYCfHdf6niCThWY/ZrgE08uIllqRMKxn/SRfUHLKU3ARMSIRo0Vdz1yxKKPudWfwjxqN
         IG3g==
X-Gm-Message-State: AC+VfDyDz5k+TyF6ko1Ab8Gi/QgKdjVCqyGcIBc/vy622Jy/DLl2LCpL
        1nBppZQn0JDaawa82RXNOYoCAyD69DGS0iufHQiqx0V4VD2/5B3y
X-Google-Smtp-Source: ACHHUZ6jFPSGzornDfPU6sgAKh3VllTFRtDWCILyDWS95jF6HhT1IKdyJrivkYZPAMWj9/Vb9M/8Jpnk3Q8SYZAr3KU=
X-Received: by 2002:a17:907:940d:b0:96f:608c:5bdf with SMTP id
 dk13-20020a170907940d00b0096f608c5bdfmr1398910ejc.64.1686043817324; Tue, 06
 Jun 2023 02:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c5b77105b4c3546e@google.com>
In-Reply-To: <000000000000c5b77105b4c3546e@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 6 Jun 2023 11:30:05 +0200
Message-ID: <CAJfpegv+SSns5oSn3ZJfpD9S1FrYHHcNWTMeK6kSr9_KmWH08Q@mail.gmail.com>
Subject: Re: possible deadlock in ovl_maybe_copy_up
To:     syzbot <syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com>
Cc:     linux-unionfs@vger.kernel.org,
        linux-integrity <linux-integrity@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

#syz dup: possible deadlock in mnt_want_write (2)
