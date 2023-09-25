Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F66CE7A81
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Sep 2023 09:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjIYJvr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 05:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjIYJvq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2023 05:51:46 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91764A3
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2023 02:51:39 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1c60c10db16so1662625ad.1
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2023 02:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695635499; x=1696240299; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6bDaROXosZFbxypZ/HbsqMYiNAkcfxciw+tGlY+rYeU=;
        b=Ww/3LeLdNSzMKLAkpPz0gj2FXArrYdSEqlsL3mQ9swSfmvzwNLykiKmrf/azIT/3fC
         qD1Yyaw8AXq421+VU15G5zhW9yo+fq+I8wf7c/I5N6c0xe52sdXzE2zypn414MeORGtN
         vYF/3CnaXOdkwSV31z0mEZ9ZlPAb3qq+RDONBiNdLJGBQVYdRRb7yQZfjg6glTh0ti1A
         cgM2+dsrOzAN/+SppAkPCWv+iIL+9yQ/WSC/6UI+MUXjt6AJddm5Ti9TvO7sLkmL316I
         D1/wBnk7xtaUqCosXKiHElN0qbZN88NUKEwKwgVUer6SVYbSQdUuIEnBhCuJElf+wyrs
         rcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695635499; x=1696240299;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6bDaROXosZFbxypZ/HbsqMYiNAkcfxciw+tGlY+rYeU=;
        b=nQ00/ug8NwC8NQYO6bSW54JnSHHdhLFAclHJjiytIO+GKUXkzwQxYeevRDpvQeojQL
         6sy8j0640Q2a0XbcnDFPVIPG0Y4Q+gvDRAEUo1xvdBXXw6gVZQFF9XaL+O27DhinS7fa
         MTm3lkoWlcuaaCjdjvppz9MIOoJwZHSg3E5vg46vRbNggKDr+wWD54TY1SiU2uTlbLdz
         RbZ79J5rBZSrCWBtJU1Xoq6S0Sk42Wz479hc/izq64QIeMdjKLxYF/PolycLBK0UCRAA
         Q6lEvqWCaJ4+nq6rcG4g4H2HufiQPhokm1wvJ9C3DKUdiKqAxHfuWjtbQUG1Sl43SshA
         TpsQ==
X-Gm-Message-State: AOJu0YwlGUcbWEMBzgHQgSS9AfjMxwObpJCCSrKhoFOlW8QaTuCbCicG
        4u7wIdm74t+iT3riurKAr3D86w==
X-Google-Smtp-Source: AGHT+IEL4SKPtQ8PAes8V97jql6XtLNcHPyUdJHnX/z3vjsVjPb+hoPuhUEeKkfGy/a39JaX+7fVTw==
X-Received: by 2002:a17:902:ecce:b0:1c4:1e65:1e5e with SMTP id a14-20020a170902ecce00b001c41e651e5emr8550430plh.0.1695635498999;
        Mon, 25 Sep 2023 02:51:38 -0700 (PDT)
Received: from smtpclient.apple (mobile-166-171-251-202.mycingular.net. [166.171.251.202])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902d35300b001bc6e6069a6sm8424373plk.122.2023.09.25.02.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 02:51:38 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] ovl: disable IOCB_DIO_CALLER_COMP
Date:   Mon, 25 Sep 2023 11:51:25 +0200
Message-Id: <10D8C1CC-07FB-47B1-8326-5EDEA53E166B@kernel.dk>
References: <20230925-desorientiert-fahrverbot-d95744ccc37f@brauner>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <20230925-desorientiert-fahrverbot-d95744ccc37f@brauner>
To:     Christian Brauner <brauner@kernel.org>
X-Mailer: iPhone Mail (21A340)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sep 25, 2023, at 11:39=E2=80=AFAM, Christian Brauner <brauner@kernel.org>=
 wrote:
>=20
> =EF=BB=BF
>>=20
>> No problem - and thanks, maybe Christian can pick this one up? I
>=20
> Snatched it I've got a pile I need to send to Linus this week anyway.
> (Thanks for the Cc, Amir!)

Perfect, thanks!

