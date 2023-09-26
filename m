Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91D1E7D246
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Sep 2023 07:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjIZHnm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 03:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjIZHnl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Sep 2023 03:43:41 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F18892
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Sep 2023 00:43:34 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id a1e0cc1a2514c-7a8b839fc0aso2315729241.3
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Sep 2023 00:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695714213; x=1696319013; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fq/2LUDCFOtnb5yVUCeVD6G/cNwgq7MLMPi8kOdDe0E=;
        b=IQTldLrbQdbzhvdogGyEs727tS6uWL8zSO8qwmeKzRHoWxesLO8/INTPiknBflvXXj
         ntpIiKMhm+hd7I5qIwsq+SRq71NgoQAKCkvwIOV1fLbtJcy1WoZRVeD+vO9AaTvPo8ha
         qzsd2yvq9eZXwYwccHImjjDeyrXC+9UwuZJofh5EeQ0zr+dPt1pGFpQZCfrlokj69rzJ
         4O9GvOVOXQ1oUT0moQ+4UaEKh9k8W4bN46VF2tezFFc1a+aohlxi9zTtTDZh6z5X7k4l
         s2pEnAOyATquze9tPa0Reat+904BE4zcg8BDUYtM8av3KITxFBR5I3JkyGqX1Qll6GnH
         rCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695714213; x=1696319013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fq/2LUDCFOtnb5yVUCeVD6G/cNwgq7MLMPi8kOdDe0E=;
        b=WFSxN1pL6SpBoJa32UfIdL6Id+4HkAbAad5wt7xMLEXY98xs1KahrV9IdcMFQNGQOS
         lSiz9Rr8MdnkqnTLFWo6FSXc2RM0J7LK2XyRD1aGME6JF4Nl1bMrg9dV1XJk1qiaTZ/x
         N3colrvvSeKY/nqpdrtGLCY7OihPmvFo7CIim8Ls1FA7Qao4zY/IILBYHyQDpWztWGUO
         RpEbnkdqYWiDCeLe93y5tskXtnCKhYR8XAY5Vukh0LOEw2LCip8+/IEumEsRliARWwXG
         0+2KTwFypYidU4pmfLz35eVzjoUz9Ucon7ErM41aQxvDp1zpi6JWZe4R9RRwtbp3h/8b
         dIiA==
X-Gm-Message-State: AOJu0YwcjlMSOn1eQX5gcJuNXYd1Z89JZPER6/9QWauZ8CNuu24RdmEo
        6ydeTwFqQvAlA0bz7jGvfQGiJOjy7DRHmacsljNTk+kXfj4=
X-Google-Smtp-Source: AGHT+IGdNvwZUszUCfai4QREdkiwTH6Pb8MeRIdVF+UoeGr7A5VrW406SQwaK6hc7IWkcdXwJtWJjjUv3hd/jfH9RmI=
X-Received: by 2002:a67:be04:0:b0:44e:9f69:fa52 with SMTP id
 x4-20020a67be04000000b0044e9f69fa52mr4289540vsq.22.1695714213402; Tue, 26 Sep
 2023 00:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <2157158b2d38f2af38a60cf2d72b08be@posteo.de>
In-Reply-To: <2157158b2d38f2af38a60cf2d72b08be@posteo.de>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 26 Sep 2023 10:43:20 +0300
Message-ID: <CAOQ4uxgzy_BB=8LeCbuP9Es3Ee6WXoOsVgrVOJTzceB7iv1bWg@mail.gmail.com>
Subject: Re: Overlayfs: Deleting files from the lower dir
To:     alexis.b@posteo.de
Cc:     linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 25, 2023 at 5:56=E2=80=AFPM <alexis.b@posteo.de> wrote:
>
> Hi,
>
> We are using an overlayfs to make our configuration persistent.
> The lower dir is /etc and the upper dir is located on the persistent
> /data partition. This is the mount command we use to create the overlay:
>
> mount -n -t overlay \
> -o workdir=3D$WORK_DIR \
> -o lowerdir=3D/etc \
> -o upperdir=3D/data \
> -o index=3Doff,xino=3Doff,redirect_dir=3Doff,metacopy=3Doff \
> /data /etc
>

What is the lower (readonly) and upper filesystem type?
Any reason that you explicitly disable redirect_dir?
I am asking because this is not a common configuration
and not one that I test regularly.

> Problem is that when we do remove a file from
> the lower dir  ("rm /etc/file1.txt" for example) and afterwards list the
> directory content with the
> ls command we do get following output:
>
> $ls /etc
> file1.txt file2.txt file3.txt
>
> $rm /etc/file1.txt
>
> $ls /etc
> ls: ./file1.txt: No such file or directory
> file2.txt file3.txt
>
>
> Like expected, the file is not listed anymore but we do get an error
> message ("No such file or directory"). When we list the directory
> using the tree command we do not get an error but the file (possibly the
> character device to white out the deleted file?) still gets listed in
> the
> output contrary to what we would expect.
>

It is very much unexpected.

> We are using linux kernel version 5.10.9.
>

Is this a regression with this kernel version?
Or is this the behavior you always observed?
Do you see any overlayfs related messages in kmsg while observing this?

>
> Any hint on why this does happen or how to solve this would be very
> appreciated.

On quick look you could try to upgrade to kernel >=3D 5.10.37 with this fix
* 0f8528c78fc8 - ovl: invalidate readdir cache on changes to dir with origi=
n

This is a fix to a bug where lower dir was removed, which is not your case,
but maybe there is something that I am overlooking.

Thanks,
Amir.
