Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1152BC433EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Jan 2022 16:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbiANQBm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Jan 2022 11:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiANQBm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Jan 2022 11:01:42 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE4C061574
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jan 2022 08:01:42 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id g5so6142759vkg.0
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jan 2022 08:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwawIenTXnKujL0dSwO8FxAy009suQCr7pwqoep9sK4=;
        b=FeQAwOpgPz/OeAr61Mw0hTzyfsGb6anNAgT2VWPtIJXPogimql6dBbSC1DN29FSGRq
         PPkDCtX2QEGWzXRkwqo6W/qgrysWB0prq+WDqZ5Cp1mLC5Rpsab3+2n7C59QtNHkPR2h
         2MYP18bzX8RKucMQiG0bMk7MMnLbDsENjwno8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwawIenTXnKujL0dSwO8FxAy009suQCr7pwqoep9sK4=;
        b=ZFPeJyhVC/VgNX/pu1FsD20icZSAT7gM4zcNzYT7Mw5p3JNl6wipROPks1uwsvuKnS
         MXsvpAAZPMcwRaO7o3CgTiwCI9VpKC9kDQr7d1nGH4A9Px/lSlLLJKPhuA5YRWi1VuVd
         d8gd6Ynm1D0kHmAK+pJi6zfuc7mpJz3Gt/QgvMELJe88Q9OWnSpomna1IJlL4wG8qvTB
         jdvRbDkR1pozcrGGk+hFMENWdGo0W/gx2evkDlUjnSvBZ1dupz3F+21dRFzkcAGLA/kL
         gg6uoyeVN+Khi+09MTAi2mYBzbe2o49Z6ghJvYg4pzxAlcGvABc3qMqmivsuXxrp1S+e
         37/g==
X-Gm-Message-State: AOAM533tHmAbjEoLJTATXSXRe8/a+JJihCxI5txK2zYdo1HuWjkvDYSl
        qOvaeWOYdp0dHLrn8Z8T2UIDe0G61iEEqho7y6Flhg==
X-Google-Smtp-Source: ABdhPJydblUGAK9M6hDbe05+Yu/2H+Alq21pSsLklYvtqtJC+Ln2EqqkbEQmxcx6kY1LEi18CV7zo8+QTrqFeiof4is=
X-Received: by 2002:a1f:a0d3:: with SMTP id j202mr4434989vke.31.1642176101268;
 Fri, 14 Jan 2022 08:01:41 -0800 (PST)
MIME-Version: 1.0
References: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
 <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com> <515a5cf0d1e35bee96e1ec9a49a46dfb545871eb.camel@googlemail.com>
In-Reply-To: <515a5cf0d1e35bee96e1ec9a49a46dfb545871eb.camel@googlemail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 14 Jan 2022 17:01:30 +0100
Message-ID: <CAJfpegt0dKEt+ThAodA3AX1xdSX3j+2FNBAv6-caMo0+gmFJVg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix NULL pointer dereference
To:     chf.fritz@googlemail.com
Cc:     Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002ce27805d58cebf1"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--0000000000002ce27805d58cebf1
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Jan 2022 at 21:28, Christoph Fritz <chf.fritz@googlemail.com> wrote:
>
> >
> > [    9.956738] overlayfs: failed to retrieve upper fileattr
> > (index/#61, err=-25)
> > [   10.311610] overlayfs: failed to retrieve upper fileattr
> > (index/#d, err=-25)
> > [   10.712019] overlayfs: failed to retrieve upper fileattr
> > (index/#e, err=-25)
> > [   31.901577] overlayfs: failed to retrieve upper fileattr
> > (index/#64, err=-25)
> >
> > These have been -ENOIOCTLCMD errors but got (falsely?) converted to
> > -ENOTTY by the recently introduced commit 5b0a414d06c3 ("ovl: fix
> > filattr copy-up failure"):
> >
> > +       if (err == -ENOIOCTLCMD)
> > +               err = -ENOTTY;
> >
> > Any ideas?
> >
>
> Doing the same "quirk" for upper fileattr seems to fix the issues, but
> I have no clue about any other implications:
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 347b06479663..1e69bc000dd8 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -167,6 +167,8 @@ static int ovl_copy_fileattr(struct inode *inode, struct path *old,
>
>         err = ovl_real_fileattr_get(new, &newfa);
>         if (err) {
> +               if (err == -ENOTTY || err == -EINVAL)
> +                       return 0;
>                 pr_warn("failed to retrieve upper fileattr (%pd2, err=%i)\n",
>                         new->dentry, err);
>                 return err;
>

Can you please test the attached patch?

It still prints one warning message to inform the user about this
situation, but otherwise it should revert to the old behavior, like
your suggested patch.

Both patches pushed to:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git#overlayfs-next

Thanks,
Miklos

--0000000000002ce27805d58cebf1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="ovl-dont-fail-copy-up-if-no-fileattr-support-on-upper.patch"
Content-Disposition: attachment; 
	filename="ovl-dont-fail-copy-up-if-no-fileattr-support-on-upper.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kyel7rio0>
X-Attachment-Id: f_kyel7rio0

RnJvbTogTWlrbG9zIFN6ZXJlZGkgPG1zemVyZWRpQHJlZGhhdC5jb20+ClN1YmplY3Q6IG92bDog
ZG9uJ3QgZmFpbCBjb3B5IHVwIGlmIG5vIGZpbGVhdHRyIHN1cHBvcnQgb24gdXBwZXIKCkNocmlz
dG9waCBGcml0eiBpcyByZXBvcnRpbmcgdGhhdCBmYWlsdXJlIHRvIGNvcHkgdXAgZmlsZWF0dHIg
d2hlbiB1cHBlcgpkb2Vzbid0IHN1cHBvcnQgZmlsZWF0dHIgb3IgeGF0dHIgcmVzdWx0cyBpbiBh
IHJlZ3Jlc3Npb24uCgpSZXR1cm4gc3VjY2VzcyBpbiB0aGVzZSBmYWlsdXJlIGNhc2VzOyB0aGlz
IHJldmVydHMgb3ZlcmxheWZzIHRvIHRoZSBvbGQKYmVoYXZpb3IuCgpBZGQgYSBwcl93YXJuX29u
Y2UoKSBpbiB0aGVzZSBjYXNlcyB0byBzdGlsbCBsZXQgdGhlIHVzZXIga25vdyBhYm91dCB0aGUK
Y29weSB1cCBmYWlsdXJlcy4KClJlcG9ydGVkLWJ5OiBDaHJpc3RvcGggRnJpdHogPGNoZi5mcml0
ekBnb29nbGVtYWlsLmNvbT4KRml4ZXM6IDcyZGI4MjExNWQyYiAoIm92bDogY29weSB1cCBzeW5j
L25vYXRpbWUgZmlsZWF0dHIgZmxhZ3MiKQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMg
djUuMTUKU2lnbmVkLW9mZi1ieTogTWlrbG9zIFN6ZXJlZGkgPG1zemVyZWRpQHJlZGhhdC5jb20+
Ci0tLQogZnMvb3ZlcmxheWZzL2NvcHlfdXAuYyB8ICAgMTIgKysrKysrKysrKystCiAxIGZpbGUg
Y2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKLS0tIGEvZnMvb3Zlcmxh
eWZzL2NvcHlfdXAuYworKysgYi9mcy9vdmVybGF5ZnMvY29weV91cC5jCkBAIC0xNTcsNyArMTU3
LDkgQEAgc3RhdGljIGludCBvdmxfY29weV9maWxlYXR0cihzdHJ1Y3QgaW5vZAogCSAqLwogCWlm
IChvbGRmYS5mbGFncyAmIE9WTF9QUk9UX0ZTX0ZMQUdTX01BU0spIHsKIAkJZXJyID0gb3ZsX3Nl
dF9wcm90YXR0cihpbm9kZSwgbmV3LT5kZW50cnksICZvbGRmYSk7Ci0JCWlmIChlcnIpCisJCWlm
IChlcnIgPT0gLUVQRVJNKQorCQkJcHJfd2Fybl9vbmNlKCJjb3B5aW5nIGZpbGVhdHRyOiBubyB4
YXR0ciBvbiB1cHBlclxuIik7CisJCWVsc2UgaWYgKGVycikKIAkJCXJldHVybiBlcnI7CiAJfQog
CkBAIC0xNjcsNiArMTY5LDE0IEBAIHN0YXRpYyBpbnQgb3ZsX2NvcHlfZmlsZWF0dHIoc3RydWN0
IGlub2QKIAogCWVyciA9IG92bF9yZWFsX2ZpbGVhdHRyX2dldChuZXcsICZuZXdmYSk7CiAJaWYg
KGVycikgeworCQkvKgorCQkgKiBSZXR1cm5pbmcgYW4gZXJyb3IgaWYgdXBwZXIgZG9lc24ndCBz
dXBwb3J0IGZpbGVhdHRyIHdpbGwKKwkJICogcmVzdWx0IGluIGEgcmVncmVzc2lvbiwgc28gcmV2
ZXJ0IHRvIHRoZSBvbGQgYmVoYXZpb3IuCisJCSAqLworCQlpZiAoZXJyID09IC1FTk9UVFkgfHwg
ZXJyID09IC1FSU5WQUwpIHsKKwkJCXByX3dhcm5fb25jZSgiY29weWluZyBmaWxlYXR0cjogbm8g
c3VwcG9ydCBvbiB1cHBlclxuIik7CisJCQlyZXR1cm4gMDsKKwkJfQogCQlwcl93YXJuKCJmYWls
ZWQgdG8gcmV0cmlldmUgdXBwZXIgZmlsZWF0dHIgKCVwZDIsIGVycj0laSlcbiIsCiAJCQluZXct
PmRlbnRyeSwgZXJyKTsKIAkJcmV0dXJuIGVycjsK
--0000000000002ce27805d58cebf1--
