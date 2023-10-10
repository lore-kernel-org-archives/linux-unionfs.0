Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692C8CD68E8
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Oct 2023 09:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjJJJGz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 05:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjJJJGm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2023 05:06:42 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96F0126
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 02:06:26 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-52bd9ddb741so9502320a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 02:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1696928785; x=1697533585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5GjFRoEsnhHtr0g30j1bXtSETq9oW+A2u3nvwC8ou0=;
        b=FnwAJfuJuiw11RyI1ssW8x3M6mzKXIILDDHB+0Diiv/RffBOLpSmJ0WFzsiNwfDKR7
         0LqtjwHSOI6p5UTrTYgwNhBiDo4opTUFwZxmMsaoZGaHr4E/+lNtWs6PGV8SaYV0NgB5
         owLJrKa0Aa3qhbzXm+dH+u4Sc6WYW7+6XJblY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696928785; x=1697533585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R5GjFRoEsnhHtr0g30j1bXtSETq9oW+A2u3nvwC8ou0=;
        b=KXovSIBv03kfCsB7KzLWAiZf16QRjkXJRRpPvTs2hQayMNEiJVSel2VCwqkx9eG7/D
         fXqW4zXel7Q9nFUHL1JFnaSjXN/cR0kRxXXMbe1ueN1O5wl8vCLlXDmWskVoSjNEzACN
         MYvr0qkfsGyGR6EC3e7JPuOts3VdryN/P/uYyglkzorZfC54EZ22+6O8xiQ40TYCyCQt
         L+mWUc7nHVAEMWYHbevedwUGBkfY2F2nS0jLuOslRXccrhAtUJtJT8R7kKLzf/lE+AHg
         qEkq3R7I5rqe5OipO+PQSuCWpzpIsaAAFfk+HSgsJSf3PpfTlm9W4V2RuBev0QrO86h6
         yJSA==
X-Gm-Message-State: AOJu0YyMKp8GAecKu+rnTMIhpX56bkdHfWZwdNfaegqwZY1AHdF8vG7V
        8xA/P4KBtHxkK4V9nivV1FE73CLX88SLR7qExyz20Q==
X-Google-Smtp-Source: AGHT+IF2nBV2UUO66UztbF1kOiMGrjios6R9qK7y2OYe1n0rvwlGM3h0dghROSZXhj/fiQj0GZUuCg+ahVxMY76fuwU=
X-Received: by 2002:a17:906:2210:b0:9b2:8323:d916 with SMTP id
 s16-20020a170906221000b009b28323d916mr17234250ejs.17.1696928785285; Tue, 10
 Oct 2023 02:06:25 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 10 Oct 2023 11:06:14 +0200
Message-ID: <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 6 Oct 2023 at 19:21, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Oct 6, 2023 at 7:42=E2=80=AFPM Ryan Hendrickson

> > And there is the escaping that needs to happen for ':' and '\' when
> > parsing the path parameters (':' is only special syntax in lowerdir, bu=
t
> > the escaping logic seems to apply to upperdir and workdir as well, base=
d
> > on my testing). Even using the new API, this is handled in the kernel.
> > We'd like to know if this escaping can be considered stable as well, an=
d I
> > don't think that's a question for the libmount maintainer.
>
> Agree.
> Unlike the comma separated parameters list,
> upperdir,workdir,lowerdir are overlayfs specific format.
>
> ovl_unescape() (for upperdir/workdir) unescapes '\' characters.
> as does ovl_parse_param_split_lowerdirs().
> Not sure why this was needed for upperdir/workdir, but it It has
> been this way for a long time.
> I see no reason for it to change in the future.

Unescaping  upperdir/workdir was the side effect of using a common
helper; it wasn't intentional, I think.  The problem is that
unescaping breaks code that doesn't expect it, and filenames with
backslashes (and especially \\ or \: sequences) are very rare, so this
won't show up in testing.

At this point I'm not sure which is more likely to cause bugs: getting
rid of unescaping or leaving it alone.

One way out of this mess is to create explicit _unesc versions of these opt=
ions.

Thanks,
Miklos
