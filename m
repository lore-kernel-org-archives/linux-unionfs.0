Return-Path: <SRS0=FkJP=45=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA266C10DCE
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Mar 2020 18:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9ED20663
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Mar 2020 18:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6pD8NYr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgCLSED (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 14:04:03 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:43251 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgCLSED (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Mar 2020 14:04:03 -0400
Received: by mail-il1-f193.google.com with SMTP id d14so5825952ilq.10
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Mar 2020 11:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tUs3z/TIvAH7tE8ggypqfQM9Wz0fAhrGs4MCsU6kUWw=;
        b=L6pD8NYrzqPxr6fFWg2qwHn7u2HCv6KWpD+Fz38hBPEzYlVcAnZlYiM8Zx0K//og0c
         69njQqidPe4zwyf/fq+G32g++9J6jVgir0j6CnbDxCK6F6JhHEfBCodKvRKQSat4BlmL
         OsZ2u/0VtSQe6qokiMN0GujEcrmfAxEWagKzv65COhse9h8Vii74n+afhZ0wMhleaZMw
         2OMjWFfbYpldEYDwCWxlY4Ztu5L8z/LFpgsL/0vmLTN0Zxnn+NOK0Ue7TdLGP1XZ81aa
         dMEZ1MgWZCujsFVeyWzQCerlzu7gIJVxxiTqIV+2KdWrXcQd795ghb3rOWKYOBwLgPKN
         nDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tUs3z/TIvAH7tE8ggypqfQM9Wz0fAhrGs4MCsU6kUWw=;
        b=sdd5aoJTx6ez37J/pPaRtoJFldlTZG350mlMHjfa4WobA2Z1zZHKxqDzpnAHP45Uvl
         Zbg6UK5zSi1i+V+FQ6Ze7txJQF0Hdmob2fNuvuNczeGfq4asqueOSf4P5nqccrFWnKLZ
         t+nf5e4u53DZKy9i3CVtXmL7jLu7LfaNqOfWL/EPzstjcoMWWkx07kkWx87vWqO+gCLr
         xs8XhW9/947Ej1F2eI2cqrta+vNHBCcNoUHfglKDeyi0us3l9N6GgbT4SomvBmL9LyZv
         KwYf7dE4otdx3apRHaIwytzmiua4Biqpztz+yHjjwxhpaDvluO/dv5M5JvrtvluLTRnQ
         YhPg==
X-Gm-Message-State: ANhLgQ0XVtuaytQuAloY+UBllFCQvLevJhml4+H+Y336TbCxti8yGaJF
        XmTvQYX7qg/63VQglv5DmrXLcC6MEAx1U6rAvbOOjRyY
X-Google-Smtp-Source: ADFU+vs4xu/Z2g8c07DP2siqxbwIcU1EJTskkXLinBLQd33koPEotrpc/qmMQcuQHODLSrcqKgy7Kds3j10uMmi7gQY=
X-Received: by 2002:a92:5b51:: with SMTP id p78mr9193919ilb.250.1584036241977;
 Thu, 12 Mar 2020 11:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200221143446.9099-1-amir73il@gmail.com> <20200221143446.9099-2-amir73il@gmail.com>
 <CAJfpegu6OUgwt1+m9ByoDzdZ-ye6sygbY5kR0SQsvVUroymk8Q@mail.gmail.com> <CAOQ4uxg+SC6UZAX+z_D9D9Y0-jvDvk44v74NT7tGGDrTmOyjKQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg+SC6UZAX+z_D9D9Y0-jvDvk44v74NT7tGGDrTmOyjKQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 12 Mar 2020 20:03:49 +0200
Message-ID: <CAOQ4uxi21v09GBq_XURYO9cOkoM6sUBC_Y9yVd1m2Oc=7K1uKw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: fix some xino configurations
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Feb 24, 2020 at 3:27 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Feb 24, 2020 at 1:41 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Fri, Feb 21, 2020 at 3:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Fix up two bugs in the coversion to xino_mode:
> > > 1. xino=off does not alway end up in disabled mode
> >
> > s/alway/always/

Just noticed I did not fix this typo, so pushed now to ovl-fixes,
along with the llseek lock fix:

5e0801c4406b ovl: fix lock in ovl_llseek()
9a69ba7f8d14 ovl: fix some xino configurations

I suppose you are getting to that.

Thanks,
Amir.
