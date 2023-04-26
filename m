Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545BFC77B60
	for <linux-unionfs@archiver.kernel.org>; Wed, 26 Apr 2023 12:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbjDZMHz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 26 Apr 2023 08:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240591AbjDZMHz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2023 08:07:55 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEB2EC
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 05:07:51 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-958bb7731a9so845089466b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 05:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1682510870; x=1685102870;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/oVZh4QBHwXC2ldSNByghTLcUjdlEVl0kRdbvR2T18c=;
        b=jAmk7rHt76VRM64apIn9Ah9bDUC1OoFUiiGAIAB0TF+QpQ3hB1tVDWZlw4PrKae/tU
         ED+rmsGNRwHAFCUMfr/zZyJh7eSv/wv0+0NZPefqYURaD3Xp6H2jnGJPIcWiosqHlzrD
         xskeCl3xbrmnxviwy5hwd24n0/k7OyX8QBwh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682510870; x=1685102870;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/oVZh4QBHwXC2ldSNByghTLcUjdlEVl0kRdbvR2T18c=;
        b=hePuZ84jFrhSr5eUcfaIxIUS5+5KryRiMol3FooQtOcdJm3BLmMvYh/aA1jB13piCA
         bJb+LBJFxHjmZB7/B7/MHJ6wW3MqasBA8vwjY90j1Xw5/ZIrHegfFZHo+jfVIYF6Ums9
         Kykp8vlbyWjxXHr8Mn4D5AuRr/g6zwvEWrY9ZYo+uxiEvNdfTFLJ1hFdAPT9B4OyeOqZ
         CUlabP8dqw5aNQ6yaVMP/1we6VeqQ4dmtuYsjMx2Ig5MDEdV/VHJDi8tXMrgo2Yggav6
         F9Hh1Gg05cbFH+t/qk9YTheoa7bHCeIsIKtD5R152cAinMdV5XJw0OpA2SaR7BWI3ro2
         beWg==
X-Gm-Message-State: AAQBX9eyMt5kNiEE8dx87Hi+6ttjuaq9fYS//Gg/Jst1mkivAKcRQ44e
        2329w0BQJZN5CFh6A/MkmCUVzgy/KMQxOMRHy/WNWQ==
X-Google-Smtp-Source: AKy350ak/dXbh5E+IMUtemLHtMO3C92wuB32gx175NvZoXbBUja29+lMdNNGE/a+0DvuAqIONK1SBIZM/XyoQWWKRBQ=
X-Received: by 2002:a17:906:1b58:b0:94f:704d:a486 with SMTP id
 p24-20020a1709061b5800b0094f704da486mr17199744ejg.32.1682510869925; Wed, 26
 Apr 2023 05:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230408164302.1392694-1-amir73il@gmail.com> <20230408164302.1392694-7-amir73il@gmail.com>
In-Reply-To: <20230408164302.1392694-7-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 26 Apr 2023 14:07:38 +0200
Message-ID: <CAJfpegu_2u2f5UXi17xQV+6iMrDVzcHQ3A9f_WCK1Yjmsud+SA@mail.gmail.com>
Subject: Re: [PATCH 6/7] ovl: deduplicate lowerpath and lowerstack[0]
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 8 Apr 2023 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
>
> For the common case of single lower layer, embed ovl_entry with a
> single lower path in ovl_inode, so no stack allocation is needed.

This makes ovl_inode grow by 8 bytes, right?  That's a win only in the
numlower = 1 case, in the other cases it's a net loss, so it might not
be worth it even without the added complexity.

Thanks,
Miklos
