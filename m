Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35BFC001E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Aug 2023 18:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbjHJSYL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Aug 2023 14:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbjHJSYK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Aug 2023 14:24:10 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562F42690
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Aug 2023 11:24:10 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id a1e0cc1a2514c-799a451ca9cso390633241.2
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Aug 2023 11:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691691849; x=1692296649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4WiUvsG7yRnO2Cwkc7w9wmIMFwDFXIIX1mXuwiQdNY=;
        b=MA2uawAJdbOaMMv6P2zYhzirrB9xISdRuyi/FvVeQ2lJhmNCkcPlx52qzLvg7QlkIY
         ww0zAZvGUgH33UhyLo7Zhh+EpODO2aBi0rmpCn/+4zXW9Ii+Cwmi1muu4HHB+9u1LaYM
         2WD5fFgnmxUdV3KfTg4OHU3m1L3B+k89I6C7b/7fp5lYMosLUp1XL5nQr7DSpyXiq28G
         cpkxQ/dtJ0jFyx2Gw+/lsV+PJqd5V2LyrYu2Rw0f+hh/UpRhdBwR14kKyVejk55wAcnM
         P9uZ+TdFtJi+lKP5XJODQxetsRMsRNPPRwFaHqAzSbK1Gp++4c3t/zTsi84tw0Pcr93a
         buEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691691849; x=1692296649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4WiUvsG7yRnO2Cwkc7w9wmIMFwDFXIIX1mXuwiQdNY=;
        b=ZG+VEBYBZZs/vYR3FxFFY/1b1C3iGMoODs7YNZhTxOqiHZMCdX2AbgWqwfV1Ssxi8I
         KgVniRq1lX7JbD3aOH4vZDSjmo2aTa48udx9pQAMoq10wb00hgJfZuV2RxGeg8yxVnuY
         H2W4MaM1ZDKXWzJZg3zewjDOlXL3gSDBiPEPSkY7EQ5TRhiSRqV1m9JjrTU22reYHfq2
         w0MpkqzHhjSvcJlTkePVR6BLU4w3Q9wlAVD6PA0r8uSTxf9qHt/XbLv9YyLt5meI8f1G
         1oc2cb/y/6+eVzx3jb95GOJnvZ+aDjNv3A548V+wYlXPoyeuHWBcrCEOxUj5ZRtwrMQG
         FqpA==
X-Gm-Message-State: AOJu0YwL0pBOMC5ITrLAFVcu+3J0X7xLMV3YdlTZmaeuRtsFo4jadgw3
        /rl2PvRX44JIcpIzql/JVRnsk5fazZz0YSHw49C4jdEQ
X-Google-Smtp-Source: AGHT+IGtoXr8CLDxeDqMusatCaaG74NrqC7uk8Bys3KGWclCqnOb22T9EgdMByQbRIIF70zzfxcD/07Tj41R/ume7+4=
X-Received: by 2002:a05:6102:34f5:b0:443:5f6e:c1b5 with SMTP id
 bi21-20020a05610234f500b004435f6ec1b5mr2482411vsb.18.1691691849388; Thu, 10
 Aug 2023 11:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230720153731.420290-1-amir73il@gmail.com>
In-Reply-To: <20230720153731.420290-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 10 Aug 2023 21:23:58 +0300
Message-ID: <CAOQ4uxg=KT6VoZ3Go5TgGtmyXTuJq8OYecBoDUTtBdmbsLx7ZQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] overlayfs lock ordering changes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 20, 2023 at 6:37=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Hi Miklos,
>
> These prep patches are needed for my start-write-safe series [1].
> This is not urgent and the prep patches don't need to be merged
> for next cycle, but I think these are good changes regardless,
> so wanted to post them for early review - if you like them you can
> queue them for 6.6.
>
> It is quite hard to do the review of the locking reorder patch from the
> diff itself and I couldn't figure out a better way to split this change.
> I've intentionally left some otherwise useless out: goto labels to
> make the patch review a bit simper - they could be removed later.
>
> On the good side, lockdep was very tough with me and it easily detected
> bugs in the earlier versions of the patches.
>
> Going on vacation. will be back round rc6.

Hi Miklos,

Have you had a chance to look at these changes?
I can queue them up in overlayfs-next if they are acceptable.

Thanks,
Amir.

>
> [1] https://github.com/amir73il/linux/commits/start-write-safe
>
> Amir Goldstein (2):
>   ovl: reorder ovl_want_write() after ovl_inode_lock()
>   ovl: avoid lockdep warning with open and llseek of lower file
>
>  fs/overlayfs/copy_up.c | 34 +++++++++++++-------
>  fs/overlayfs/dir.c     | 71 ++++++++++++++++++------------------------
>  fs/overlayfs/export.c  |  7 +----
>  fs/overlayfs/inode.c   | 56 ++++++++++++++++-----------------
>  fs/overlayfs/util.c    | 18 +++++++++--
>  5 files changed, 97 insertions(+), 89 deletions(-)
>
> --
> 2.34.1
>
