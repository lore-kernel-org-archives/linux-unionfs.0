Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694EFC04A68
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jul 2022 13:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiG1NGf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 09:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiG1NGf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jul 2022 09:06:35 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396A241988
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jul 2022 06:06:34 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m8so2085050edd.9
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jul 2022 06:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJrFfnKmFo4QAie6XYpJ0ygm3iVgWC2NF/+GXv9X4iI=;
        b=a7tJamtdDK2k5uAXlh8fWYQp34tcOtvSNsVx/UbMTCrrCTENCTecqwocYhMXd4HBSH
         rzY/n+pOnSwD+XfGa6sdEMDHIppnVp+PMYyRwaWhPPAXLkTNrtB9G9hKXFIoTWfeTpwL
         n2Ha57HGUIma49JcqjlMxsJLopYZJ2d0sW+xk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJrFfnKmFo4QAie6XYpJ0ygm3iVgWC2NF/+GXv9X4iI=;
        b=MCF7JRe+VqsIUZMVTZSuuoUh5V3dHLqkp5dAAQBY7qfhDrIYErl1C2b5YYG0XhUblI
         1FXpNkOPf6ivVoYa0HyNaykNxzfHoY1RO3ZKd0VqoUwlQ9JEiv59on4C+Sq6EYt5CuKi
         DN1M0Ss1WOo15j2/XtuKmQ3JTrlItl4Jf109sq34Ar3vIvUFzE0gues5jwip/eYdNMTr
         QiD/UVbaCShUHw8Qcr3Dk98eT+SClXZ15n67bjo1A93wvD7D0YH8D8Db0Jn1HWjE2TI9
         8Bw2zxFWr6HIjmAmWK0uj5cV6wvMA3jKcrvZygayK+dWbbUDnTl3JQLSRaQQiig+U6Aj
         805w==
X-Gm-Message-State: AJIora+psHEFfXZCvcGcODFavuKTDxeqBj4wnZfaMuqmP0Ms9KTgAthz
        ib/SsufRji0HaWQP4ruQZM1HaiM/ZBHySVmWGxY2cg==
X-Google-Smtp-Source: AGRyM1twtFluSZsZS5bg/DA4LDyb8IH/0lz+prQn3ingk54jLyx8Bu3IXfYbcsCq/zoJG3hbpDKStCy479KzaXELev8=
X-Received: by 2002:a05:6402:34d2:b0:43c:216:a56c with SMTP id
 w18-20020a05640234d200b0043c0216a56cmr19320073edc.40.1659013592685; Thu, 28
 Jul 2022 06:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <1658976564-2163-1-git-send-email-xuyang2018.jy@fujitsu.com>
In-Reply-To: <1658976564-2163-1-git-send-email-xuyang2018.jy@fujitsu.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 28 Jul 2022 15:06:21 +0200
Message-ID: <CAJfpegvyhaUAbVYmkAwfkrgsAeauU54GxMWt4fD89TB-zAGXWg@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs: improve ovl_get_acl
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 28 Jul 2022 at 03:48, Yang Xu <xuyang2018.jy@fujitsu.com> wrote:
>
> Provide a proper stub for the !CONFIG_FS_POSIX_ACL case.

Applied, thanks.

Miklos
