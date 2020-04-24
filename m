Return-Path: <SRS0=0l2z=6I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456AAC2BA1A
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Apr 2020 06:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F8720700
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Apr 2020 06:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Top9xbzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgDXG1R (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 02:27:17 -0400
Received: from [163.53.93.251] ([163.53.93.251]:25394 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgDXG1R (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Apr 2020 02:27:17 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587709582; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=TJfmqQAbmd7Djng5iHmgMA9GqKM/UQ9HekBXSEcg+Eq1cdhdD8ADj6tb/FrUUtTfFjKsEj/lazGGLSPOQgcOe7ukKkAgrGVpuJeoaC38fjg5tlJNOwSu/a1Vo7dOmnfW2Ajoh/G4hfcWHU9RlrCQ/R6a0A5TusyjGI+c0nvMDDk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587709582; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=3Z5O+Am+u2Jz1Ec5kryUBgE8BiXmAIgUzWZ5TJdzOfM=; 
        b=qf0t8VUmt0CuC6urpclq4ndZ2gB8lgF+nimMYQh5PBeHRVqSlSdCQiDaLELPvQUp8FTmL5V6r7d1c6zazopI7UU8SMbQLb+yQejhCIGVOW0ePSBT1DtR09j0l9aS9108jvXipbFa9OrTJFb3Iw7SkFMewvKg+HBNl02zGUYrhck=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587709582;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=3Z5O+Am+u2Jz1Ec5kryUBgE8BiXmAIgUzWZ5TJdzOfM=;
        b=Top9xbzQTWqNPxI8/Ur+csu4cEDuF/ntwvhE0HLKg5wb0hsT0+CLaGpvOQ/MxJqr
        I7X/tJUMjdNB4W9Es+DUfN39qQHbbhX4U+xwifaxdJV0woY43NfpK63FJa3vtkaBZdw
        5FRsw2TH/kMCLPCIiHodMz/7TvtE0qpxOU0o76lk=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1587709581673374.8847369102866; Fri, 24 Apr 2020 14:26:21 +0800 (CST)
Date:   Fri, 24 Apr 2020 14:26:21 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <171aadd9966.100e576ad1248.8616898883060201949@mykernel.net>
In-Reply-To: <CAOQ4uxhowSRqD9kSoUHg+D8-RdxF8vBbTauTchgnpG5MoSNSEA@mail.gmail.com>
References: <20200422102740.6670-1-cgxu519@mykernel.net> <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
 <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net> <CAOQ4uxhowSRqD9kSoUHg+D8-RdxF8vBbTauTchgnpG5MoSNSEA@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-24 14:02:00 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > > +               case OPT_WHITEOUT_LINK_MAX:
 > >  > > +                       if (match_int(&args[0], &link_max))
 > >  > > +                               return -EINVAL;
 > >  > > +                       if (link_max < ovl_whiteout_link_max_def)
 > >  > > +                               config->whiteout_link_max =3D lin=
k_max;
 > >  >
 > >  > Why not allow link_max > ovl_whiteout_link_max_def?
 > >  > admin may want to disable ovl_whiteout_link_max_def by default
 > >  > in module parameter, but allow it for specific overlay instances.
 > >  >
 > >
 > > In this use case, seems we don't need module param any more, we just n=
eed to set  default value for option.
 > >
 > > I would like to treate module param as a total switch, so that it coul=
d disable the feathre for all instances at the same time.
 > > I think sometimes it's helpful for lazy admin(like me).
 > >
 >=20
 > I am not convinced.
 >=20
 > lazy admin could very well want to disable whiteout_link_max by default,
 > but allow user to specify whiteout_link_max for a specific mount.
 >=20
 > In fact, in order to preserve existing behavior and not cause regression=
 with
 > some special filesystems, distros could decide that default disabled is
 > a reasonable choice.
 >=20
 > I don't understand at all what the purpose of this limitation is.
 >=20

If user sets a ridiculous  link_max which is larger than valid range of upp=
er fs, I think it is hard to verify in the stage of option parsing.
So I hope to fix the upper limit using module parameter, we can set default=
 mount option to  0/1 for the use case you mentioned above.


Thanks,
cgxu


