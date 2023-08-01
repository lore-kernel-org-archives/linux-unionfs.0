Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D89C001DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Aug 2023 17:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjHARnV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 13:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjHARnU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Aug 2023 13:43:20 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E9710C1
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Aug 2023 10:43:18 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-99bdd262bb0so863804766b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Aug 2023 10:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1690911797; x=1691516597;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f36gOBPIy1Zmguze7mrHnn3xV4XJM8s2rEorRuGLnXc=;
        b=Zi1hII0MO9R5yWLVXT8B+0SQ0LjH3M3E/oT4RuK3eRJyYEq7xNP84v3HGk/HUSDngL
         07/vNKIUsCHhOeYc6y1n4veCmp8wi9+Pgd3RqnsX57ItndaJ+Xb6fctJB3ewKB/eR9Ai
         QtQyVhVmYrV4Z6Oewnn40D5I9FK1HHwbOGKss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690911797; x=1691516597;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f36gOBPIy1Zmguze7mrHnn3xV4XJM8s2rEorRuGLnXc=;
        b=FQt5EsDsa7HXA02MaaDdS1yr8G4ni+yTLI+c/pnh4nhaIAowtgidZicGqr03qxTvDj
         VJolxZS/k/75sL4fxa3PT0Yge1pWCCfRI1A8s4qhdfl714pV1y5uUUl8hjNd1/bAmEV9
         0lPO3DqIpVAjqqrl50L/UglZq6t5mjP/Y8tJtfGw23GMCaQykLZ+M46jg1Pc7PG18IIz
         aXCRTXs9StD2sKS4Qw9g9ynHl/46+6zvzXttTROuIIxwmrs4ONykO1JwgXge1qk7PVeW
         v6hhEHIWjvAl1yptpxCHIC7bqRM8wWpn9n4wwz2KR2qlVyGQqO1LVrdKCoUoyRurhERT
         1dkQ==
X-Gm-Message-State: ABy/qLZxFYNpWzM1Nw916J4zp2dQQb2XtZHD3xIk34zTYaLr0JMQO6tz
        4ajSGwMtJwQtC3IDuLqpojI+Qum7ZrQwyVVuW4GDng==
X-Google-Smtp-Source: APBJJlFc3tECXtwdT1fGKtwv5Y7sZ3DeX9Zxcc5NxZqOazeNZ/DxzNWV68X6gHOVSrO26ZWckR39AVWL7lfgF5Y0rWM=
X-Received: by 2002:a17:906:649e:b0:987:16c6:6ff3 with SMTP id
 e30-20020a170906649e00b0098716c66ff3mr3243440ejm.38.1690911797040; Tue, 01
 Aug 2023 10:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230720091436.399691-1-yunlong.xing@unisoc.com>
In-Reply-To: <20230720091436.399691-1-yunlong.xing@unisoc.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 1 Aug 2023 19:43:05 +0200
Message-ID: <CAJfpeguygW3JY5L5d+87+V538hAWu2tL9Yksg5p-QMP3ppv13w@mail.gmail.com>
Subject: Re: [PATCH V3] ovl: fix mount fail because the upper doesn't have space
To:     Yunlong Xing <yunlong.xing@unisoc.com>
Cc:     amir73il@gmail.com, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhiguo.niu@unisoc.com,
        hongyu.jin@unisoc.com, yunlongxing23@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 20 Jul 2023 at 11:15, Yunlong Xing <yunlong.xing@unisoc.com> wrote:
>
> The current ovlfs mount flow:
>
> ovl_fill_super
>  |_ovl_get_workdir
>     |_ovl_make_workdir
>        |_ovl_check_rename_whiteout
>
> In ovl_check_rename_whiteout(), a new file is attempted to create.But if
> the upper doesn't have space to do this, it will return error -ENOSPC,
> causing the mount fail. It means that if the upper is full, the overlayfs
> cannot be mounted. It is not reasonable, so this patch will omit this error
> and continue mount flow.

Wouldn't mounting without upper (two or more lower layers) work in this case?

Thanks,
Miklos
