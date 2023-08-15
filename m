Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E28C04FDF
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Aug 2023 20:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238358AbjHOUhr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 16:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238693AbjHOUhj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:39 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF32A2110
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 13:37:05 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b9cdba1228so93401971fa.2
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 13:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692131824; x=1692736624;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KZTo6XdqYaKXacmEopjCl5CDpMbRF+JheqJwGxzGk+0=;
        b=FW4W8WdmgR8dNMtrYu3ETLxIj66T1s/tHEkjRSb8OrN4X3X4Z7+ogiz5qI1Hpelg6p
         t9fbOLM9m1+vGemnc1bD1BW+vqofJDCwJvGZCUrZjwfR6FkqgeVSXYZHtOZOaDAf2z4X
         gN9zbtKjU13IjVXJBcaYrCA9NiZHQufEnjZYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131824; x=1692736624;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZTo6XdqYaKXacmEopjCl5CDpMbRF+JheqJwGxzGk+0=;
        b=bLjVs53nbmbDiTn/x5Vn6de4uTSk0mN05jeOREFHie7P7hdwvrcNFZr8qu4lzU1SGW
         To2aZlA1cpIfV5dRUbf0sFFhqvcBgZXNtacp1ipAaveOIdBe9KrZqKKfyc2qRbFswRWP
         3wn4N51xZz+YvTS2QaM1ErqTJ2fi0hDmJ9YgIsOUpP/QZlrdSZYcUtEHQMc4Svneqx+X
         /tliaUloicgIokJZvvZZpN2uF3ppcLcycH7RIZXY75poruZl8ULO4VoPUwfLD4Eijl67
         L4o0dvK0Vy9MSGKmI6pcdL3CG86IRb0Wxdc/H2PIlRAZUu3X3gvX/mEqcU2UjdfeSVh5
         wksw==
X-Gm-Message-State: AOJu0YwGojMoO0Lcj9SIR4Z0E77sfEdEQs48lyQZFnkwzb/DiYSxESXT
        YIaVeoiV6c1dMt8AwXhNW49KC+R8itjqQNdzwMz2mw==
X-Google-Smtp-Source: AGHT+IHSUfqnUH9hiwSnMRnVECPDC7A88sO6yFLLxD+FL8U+Ic/kMpx/0EBiDFetTlg577aDnClMjCiihm5MHJmm/eA=
X-Received: by 2002:a2e:854c:0:b0:2b7:b9ca:3eda with SMTP id
 u12-20020a2e854c000000b002b7b9ca3edamr9750690ljj.34.1692131823711; Tue, 15
 Aug 2023 13:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230814140518.763674-1-amir73il@gmail.com> <20230814140518.763674-3-amir73il@gmail.com>
 <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com>
 <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com>
 <CAJfpegudye=2e2BWtk+fmaKMN_vUnwsKM8fi-GPcEX5n_vEizQ@mail.gmail.com> <CAOQ4uxi5oF7HWudQ7BBN9Matpsc2jqcftKZNH2Wpc778YK0mNg@mail.gmail.com>
In-Reply-To: <CAOQ4uxi5oF7HWudQ7BBN9Matpsc2jqcftKZNH2Wpc778YK0mNg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 15 Aug 2023 22:36:52 +0200
Message-ID: <CAJfpegssz5jpMBZs871QHuVfjA8ODvnc2_kN9YXw53Q7e47gLg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ovl: do not open/llseek lower file with upper
 sb_writers held
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 15 Aug 2023 at 21:51, Amir Goldstein <amir73il@gmail.com> wrote:

> What I meant is, except from emergency remount rdonly and fs specific
> cases like ext4 remount-ro on error, is there a way via new mount API
> that users can request remount of the upper SB rdonly, despite the
> fact that this sb has private writable mount clones?
> even if ovl has elevated mnt_writers of upper_mnt?

Private and public mounts are completely equal in this regard.  So no,
you can't remount rdonly if upper mnt has an elevated mnt_writers.

Thanks,
Miklos
