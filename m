Return-Path: <SRS0=DgkE=AT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FF3C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 08:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB66621974
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 08:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="MqBDUESF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgGHIhU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 04:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgGHIhU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Jul 2020 04:37:20 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BE3C08C5DC
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2020 01:37:20 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dp18so49441432ejc.8
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2020 01:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vQ+v3aIZYWw7wnqueEAoXEMlQSE+b+furljl9KknkZE=;
        b=MqBDUESFdIFwoKMpOpBfv5oIIOZE/qmq8F1c9UFDh2IuEaBhl/8qCveyt/l53KI/Qn
         BX+u2OTrZjteqNU+dBjegZMNj5JTpuGDB8EPNhjupElVq8ZxTq1h/d0dk28DeGbd5M7G
         w2rR0qBXgWsxQxWe9my3frTmalTSkF2vBcKsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vQ+v3aIZYWw7wnqueEAoXEMlQSE+b+furljl9KknkZE=;
        b=H2VoLM4a1MVsI9tYize5QEUAPW3D17sfVMLas4bplVG1ctPNb5LkXhm2YogcKFqdUW
         i0i7HUoZjd9gTOAtL05CPCvlluSJecjQKKmHfSZ0J9DOI5QaKeP23ESeu6UKEh4TATdc
         7WXcKvIhKFLwdq5nsPr10bkSWq4KKAdxa4DqagY/KOni6lB2+CAQFhLz6t81rFvhjWet
         3d47/VOxiAbZdvIEz3baZgUZ0Z136y/kn36+HwgNDPESvlliw176jQGERSTkMajS02Sf
         tDOcMcUCX6GQO+XAHuUvSEahZI9oCez9ldqANJOwxznEbohD3wgobYWKHdjgPhn9HLCO
         u4Bw==
X-Gm-Message-State: AOAM532irkhi0Sj8oL4O3uLOo74fCHwPYGDWvnxGehypAkY53bgbqxWY
        V4fz9nxwX42UMAQfGBHYpmXoq6BckCZ4wbUX80JHHQ==
X-Google-Smtp-Source: ABdhPJyyLWIF34CZbeCiokrgelno/6cLOysaOaQCWjPV1cZfqMSkfn7y40TKTnO93B0oKvhgsUDjF90ix+7AXTRhSlA=
X-Received: by 2002:a17:906:144b:: with SMTP id q11mr38191976ejc.511.1594197438870;
 Wed, 08 Jul 2020 01:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop> <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com> <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
 <20200707215309.GB48341@redhat.com> <CAOQ4uxhd+kYzaDmndCV5rgiswfHnyLjZokmUa+BVk9t31C=HWg@mail.gmail.com>
 <CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com> <CAOQ4uxgaVD_DjU5DM+rXzkqpgVLWN-R+kj5ef2SBvvvCDL3d6w@mail.gmail.com>
In-Reply-To: <CAOQ4uxgaVD_DjU5DM+rXzkqpgVLWN-R+kj5ef2SBvvvCDL3d6w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 8 Jul 2020 10:37:07 +0200
Message-ID: <CAJfpegur+DfoGA4e+R2okSmso59Kx0ArnkpJ03o9qM1KH5rLdg@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 8, 2020 at 10:31 AM Amir Goldstein <amir73il@gmail.com> wrote:

>
> 1) is not problematic IMO and the simple patch I posted may be applied
> for fixing the reported issue, but it only solved the special case of null uuid.
> The problem still exists with re-creating lower on xfs/ext4, e.g. by
> rm -rf and unpacking image tar.

How so?  st_ino may be reused but the fh is guaranteed to be unique.

Thanks,
Miklos
