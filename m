Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8309C7EE22
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 May 2023 21:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbjENVA0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 May 2023 17:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjENVAZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 May 2023 17:00:25 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F399F10CC
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 14:00:23 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id ada2fe7eead31-4360e73d0d4so4839388137.1
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 14:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684098023; x=1686690023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgVuSD2RuLJCfg6dHr+MCp/7rB6CIagXg1lbldIiUNU=;
        b=hWf2p8d6uDTxObl6LOd1zEHhlVWGjJVA+mEPz5hb/QUYuYgRdv2W6z1AmDtNXI/dXX
         jCjMHSv8aCp6Mpwv/4fbFWo8468w8aT2Cs4+eZyl4emQHXOwgS9v6cPR/9eBJ/wBh7E8
         DRYxBvvEwP9W1/ohdI9Tz1/i09Llz/wqmHDafJAl/zpmtLSei1/AKJAxs9Cys9ScOe7L
         cFD8iDyyXeSFEJzr3uUMwB2Dkyyr3UeKKK476vshysfN4jsnzrU94ozJtjEOEIMOmY93
         WCJMXQlz/RZTxNTt2SLcPSO0j3IATU36iH0FaksVPnithV00qdzYDCLeOD4o0qhY2mHM
         TXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684098023; x=1686690023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgVuSD2RuLJCfg6dHr+MCp/7rB6CIagXg1lbldIiUNU=;
        b=fR0gVJBGrTjijjA32XdNnlJBTV3e9I4IU69xgRFLa+jGgqC3G9YjCxH8KbaS6LHJvK
         4/zUrvcJd6236wehBvE8GltwrFCqQ/g7+r6GFJed/NoN0fN+l3PeOBR2EvkU3CzMptM+
         FomSGWVa4YAj7picT+XB+bg+oExRzacsGZnk1KsCvXp+7a8IuqdYeEhIMTB30dvSeQkC
         jka0KVk9w7eF8Uh0acziPyxOwQ1FjiAxEutIV5CIHDFXbl7RFh0p48c7nw+qi6goEvs1
         lIfibmlXZjN56NgkL9w/U6Lntw9Go2R8iumymoWN2n7OSYw5WUAQnwCgOJqhNOkl/uR2
         qrgA==
X-Gm-Message-State: AC+VfDw+24KrA0klCVhKeIEKJquSqu8E1EWg8GAePYS1/0Xu2Ioo2zHh
        jDweO5CX+PAk5hJTW6tW294Uu50A4PnHSNsqhYk=
X-Google-Smtp-Source: ACHHUZ6B4BnGp8+e+pOB2fkIO92+qzZt0yRLxsev+1jV6NnT4Phe1/h+adjVimlaBW9iz3MCPZ3d8KO0XCJWs4lF1ec=
X-Received: by 2002:a67:e8d8:0:b0:42e:4f6a:d077 with SMTP id
 y24-20020a67e8d8000000b0042e4f6ad077mr12359207vsn.4.1684098022983; Sun, 14
 May 2023 14:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
 <20230514191647.GD9528@sol.localdomain>
In-Reply-To: <20230514191647.GD9528@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 15 May 2023 00:00:11 +0300
Message-ID: <CAOQ4uxhEq8u37YNnqQmLbybJy1Kkg3Qk0TVtRZQP-yHt8CMmWA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Eric Biggers <ebiggers@kernel.org>,
        Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 14, 2023 at 10:16=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Wed, May 03, 2023 at 10:51:38AM +0200, Alexander Larsson wrote:
> > When resolving lowerdata (lazily or non-lazily) we check the
> > overlay.verity xattr on the metadata inode, and if set verify that the
> > source lowerdata inode matches it (according to the verity options
> > enabled).
>
> Keep in mind that the lifetime of an inode's fsverity digest is from when=
 it is
> first opened to when the inode is evicted from the inode cache.
>
> If the inode gets evicted from cache and re-instantiated, it could have b=
een
> arbitrarily changed.
>
> Given that, does this verification happen in the right place?  I would ha=
ve
> expected it to happen whenever the file is opened, but it seems you do it=
 when
> the dentry is looked up instead.  Maybe that works too, but I'd appreciat=
e an
> explanation.

Hmm. I do not think it is wrong because the overlay file cannot be opened b=
efore
the inode overlay is looked up and fsverity is verified on lookup.
In theory, overlay inode with lower could have been instantiated by decode_=
fh(),
but verity=3Don and nfs_export=3Don are conflicting options.

However, I agree that doing verify check on lookup is a bit too early, as
ls -lR will incur the overhead of verifying all file's data even
though their data
is not accessed in a non-lazy-lower-data scenario.

The intuition of doing verity check before file is opened (or copied up)
when there is a realfile open is not wrong, it would have gotten rid of the
dodgy ovl_ensure_verity_loaded(), but I think that will be a bit harder to
implement (not sure).

My suggestion for Alexander:
- Use ovl_set/test_flag(OVL_VERIFIED, inode) for lazy verify
- Implement ovl_maybe_validate_verity() similar to
  ovl_maybe_lookup_lowerdata()
- Implement a helper ovl_verify_lowerdata()
  that calls them both
- Replace the ovl_maybe_lookup_lowerdata() calls with
  ovl_verify_lowerdata() calls

Then before opening (or copy up) a file, it could have either
lazy lower data lookup or lazy lower data validate or both (or none).

This will not avoid ovl_ensure_verity_loaded(), but it will load fsverity
just before it is needed and it is a bit easier to take ovl_inode_lock
unconditionally, in those call sites then deeper within copy_up, where
ovl_inode_lock is already taken.

I *think* this is a good idea, but we won't know until you try it,
so please take my suggestion with a grain of salt.

Thanks,
Amir.
