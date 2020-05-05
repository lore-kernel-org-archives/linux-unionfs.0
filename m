Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EA1C47257
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 16:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1970F206A4
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 16:13:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dl5hTdM1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgEEQNd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 May 2020 12:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730452AbgEEQNc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 May 2020 12:13:32 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1803C061A10
        for <linux-unionfs@vger.kernel.org>; Tue,  5 May 2020 09:13:32 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w6so1022706ilg.1
        for <linux-unionfs@vger.kernel.org>; Tue, 05 May 2020 09:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vn7jLwEt6eVi+HCG+zYGkHWm4bgZCNnQhRFA7NhbgCY=;
        b=Dl5hTdM1qUikT2a9UnHGb3rKsAFNbHPV3krRpWC5bYH0oujyj8kq8zjbACS6gf0KyY
         +8w8r/iKD2/xS0hENqtgOHRDjhnYvkKMsvfdankM/fpJIEnG9QC3zNNiGBFv8cl18Tat
         oCbfRsTBXsqtQ5axBRMiYxk9+L8YX3lQTllPR8KFB1g3TogfkoXJsg+yBXKCMYA/oT8y
         W2LDFYZaJwTYVAVt7cFjJ373wiMPhWSQGnKQBhukDy38Ag1GAxvlsRQ2OSLWJN/8kuzi
         uqPeH5U+1tD5EXsANnz4igM8fssjHaNldt1No4C+rpEXtU/i1xZMmYEG48bJTJHRe/sn
         /7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vn7jLwEt6eVi+HCG+zYGkHWm4bgZCNnQhRFA7NhbgCY=;
        b=jiVRZWP3BAfV/y1yYf3NBdMHwjh2mELDBuaLOZM+tgz3Toa1kQCrOlNb8h6/Vjfl7u
         xGpjELgcQNi49CWqjtTe2YpnIjEgKwBD7+fPgUeLP3OMxkTIUFJR1WlET6UWbwHa0BdP
         TNgu+qlMtuF4SHmQJcYGCT3Xd+Pler204jouqRth7OFp9kgg0TTupcjlqhM/n37Aie3j
         6Ho1CxeLlcPzD93APcnv2FU1YQEsnmivFZsz8vZLbc2FwcfHZ/nw3eaOP6aWepHnH4Hl
         tbO1ZPwPmuBnNTQGDUzH1CGfVSqvSzgjdMGqUZRCx58XBziyepEmVt8OTo3W5zUKL1AG
         uSNA==
X-Gm-Message-State: AGi0PuaAb0hT0hJl5p+pYBDctEqNgfJ1wM2aRrlBUnR1tbTy59B7ac0+
        ihzu1HHCxxy5vtFWwrO+lHAiN98D7O+owjYpCD4=
X-Google-Smtp-Source: APiQypIH201NOWb4iZswKbF64zdx+iKI1y79IiXp65JtEHzLb2dSF3/3LvCB0SI4Nt/nn0OgqnXtSPbzZCzd5S4PbHU=
X-Received: by 2002:a92:9e11:: with SMTP id q17mr4535609ili.137.1588695211842;
 Tue, 05 May 2020 09:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200505135026.GA38935@mwanda>
In-Reply-To: <20200505135026.GA38935@mwanda>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 5 May 2020 19:13:20 +0300
Message-ID: <CAOQ4uxj0F9V=FOUANKSATR2E==BoLr6OJMqsJe5QCbOLNR0k0A@mail.gmail.com>
Subject: Re: [bug report] ovl: make sure that real fid is 32bit aligned in memory
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 5, 2020 at 4:50 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Amir Goldstein,

Hi Dan,

>
> The patch cbe7fba8edfc: "ovl: make sure that real fid is 32bit
> aligned in memory" from Nov 15, 2019, leads to the following static
> checker warning:
>
>         fs/overlayfs/export.c:791 ovl_fid_to_fh()
>         warn: check that subtract can't underflow
>
> fs/overlayfs/export.c
>    775  static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
>    776  {
>    777          struct ovl_fh *fh;
>    778
>    779          /* If on-wire inner fid is aligned - nothing to do */
>    780          if (fh_type == OVL_FILEID_V1)
>    781                  return (struct ovl_fh *)fid;
>    782
>    783          if (fh_type != OVL_FILEID_V0)
>    784                  return ERR_PTR(-EINVAL);
>    785
>    786          fh = kzalloc(buflen, GFP_KERNEL);

Doesn't Smatch warn on possible kmalloc(0)?
That can't be good. Right?

>    787          if (!fh)
>    788                  return ERR_PTR(-ENOMEM);
>    789
>    790          /* Copy unaligned inner fh into aligned buffer */
>    791          memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);
>                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>    792          return fh;
>    793  }
>
> Samtch thinks buflen can be "0,4-128".  OVL_FH_WIRE_OFFSET is 3. The
> problem is that 0 - 3 is a negative and the memcpy() will crash.
>
> In do_handle_to_path() we do:
>
>         handle_dwords = handle->handle_bytes >> 2;
>
> Handle ->handle_bytes is non-zero but when it's >> 2 then it can become
> zero.  It's a round down.  In ovl_fh_to_dentry() we do:
>
>         int len = fh_len << 2;
>
> If we rounded down to zero then "len" is still zero.

I agree with your analysis.
The reproducer should be trivial because there are no sanotify
checks prior to buggy code except for fh_type != OVL_FILEID_V0.

> Obviously one fix
> would be to add a check in ovl_fid_to_fh().
>
>         if (buflen < sizeof(*fh))
>                 return ERR_PTR(-EINVAL);

Correct fix IMO in the context of ovl_fid_to_fh() should be:

if (buflen <= OVL_FH_WIRE_OFFSET)
                 return ERR_PTR(-EINVAL);

Just to avoid the crash.

>
> But that feels like papering over the bug.
>

It won't be papering over, because of the check:
        err = ovl_check_fh_len(fh, len);

This was the check before the offending commit that was responsible
for sanity checking the value of len, but the commit slipped in this
code before the sanity check.

I assume you will be sending the patch.
I will put writing a test on my TODO.

Thanks,
Amir.
