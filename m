Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08ECC433B4
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 09:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6DF261452
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 09:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhDVJEH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 05:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhDVJEC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 05:04:02 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9C3C06138B
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 02:03:27 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id r18so16625922vso.12
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 02:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jkOIvdxq5FpHGptZhXhCv3A+fIf8KDwGus1f56zSjAo=;
        b=aFZLDkWH4F2K6FRu5HB2i7UIRTLZ0gkGrGtHfyUt7228PJ+dlq12bN2GhdAwE0fucU
         Z1blO//QhtpdjT3L97gqp3waWG+HrBA/iCOocXcdGEbI6kHNeHc+zmykPZl+LhQbvGjo
         hxK18brtShk8VicDVZE/EsyXHVDo2Kdik2RXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jkOIvdxq5FpHGptZhXhCv3A+fIf8KDwGus1f56zSjAo=;
        b=ZLfxnu5nJIhgQri+Q4Ow802HNUysctiCE/5f8kkkBTqouGRCvsIi17j8HoZJVhoMyN
         Vprb0J17/Bdkg42zVwvgRztJT/GvKS35x0qx1IuIvWW90uQkkn6qwWlHNJr9inGAfsRA
         IDU/PNL1dnU6ocGwqp3/nR8BmoqeTEEhZ5h2liRdlHM3Co1RsSdPAXi1QcuwJ0hOUsul
         ayhe1Y3AAeRkmagoEMin7NxFHOA2WBYuXto6XywiIN7dbh9TemvmG8RZOXp6POvUY4n8
         faTVblWEJC5s6o6mz8z9B/14qtez/gdymldOggKiwgvL4XkZi40RMYbZa+GPAXsGYybi
         qlEA==
X-Gm-Message-State: AOAM530W9lMczoiiR0EaOyNWDB/VRVASFiUkix/bhnDrdlYG3/XGjhv/
        SrpRDKrB0uaslZxVO3Ww1hYaXgXQpIf9htqmv0qCFg==
X-Google-Smtp-Source: ABdhPJx2hoyiPNujGpck3t+xLYt+bZFhALFQCuDC3DQpdO8AVJOpmi7M8sesjQGMikbR49vd7sC/vVqMM/xxGTc2QYk=
X-Received: by 2002:a67:b005:: with SMTP id z5mr1559221vse.47.1619082206128;
 Thu, 22 Apr 2021 02:03:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210421092317.68716-1-amir73il@gmail.com> <CAOQ4uxhh305WPZ-puLONej2TLQTe54-FUtrsgp2R8ohdDcNP0A@mail.gmail.com>
 <CAJfpegtoTJRnNQnttVw54pndEqrpzfxttp=NCQ_2za859fWMqA@mail.gmail.com> <CAOQ4uxgZemF+wYzorW8s2+4=1dRds3EKkKBs=bybdhrTC-QMJg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgZemF+wYzorW8s2+4=1dRds3EKkKBs=bybdhrTC-QMJg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 22 Apr 2021 11:03:15 +0200
Message-ID: <CAJfpeguOFM=CKtxH537BhGjMufNK6aVTUfV_opn81vw1m8iaZw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Test overlayfs readdir cache
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000c2f54905c08bf388"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000c2f54905c08bf388
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 22, 2021 at 10:47 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 10:53 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Thu, Apr 22, 2021 at 8:18 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Wed, Apr 21, 2021 at 12:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > Eryu,
> > > >
> > > > This extends the generic t_dir_offset2 test to verify
> > > > some more test cases and adds a new generic test which
> > > > passes on overlayfs (and other fs) on upstream kernel.
> > > >
> > > > The overlayfs specific test fails on upstream kernel
> > > > and the fix commit is currently in linux-next.
> > > > As usual, you may want to wait with merging until the fix
> > > > commit hits upstream.
> > > >
> > > > Miklos,
> > > >
> > > > I had noticed in the test full logs that readdir of
> > > > a merged dir behaves strangely - when seeking backwards
> > > > to offsets > 0, readdir returns unlinked entries in results.
> > > > The test does not fail on that behavior because the test
> > > > only asserts that this is not allowed after seek to offset 0.
> > > >
> > > > Knowing the implementation of overlayfs readdir cache this is
> > > > not surprising to me, but I wonder if this behavior is POSIX
> > > > compliant, and if not, whether we should document it and/or
> > > > add a failing test for it.
> > > >
> > >
> > > I think the outcome could be worse.
> > > If a copied up entry is unlinked after populating the dir cache
> > > but before ovl_cache_update_ino() then ovl_cache_update_ino()
> > > and subsequently the getdents call will fail with ENOENT.
> > >
> > > This test is not smart enough to cover this case (if it really exists).
> > > I think we need to relax the case of negative lookup result in
> > > ovl_cache_update_ino() and just set p->whiteout without and
> > > continue with no error.
> > >
> > > This can solve several test cases.
> > > In principle, we can "semi-reset" the merge dir cache if the dir was
> > > modified after every seek, not just seek to 0.
> > > By "semi-reset" I mean use the list, but force ovl_cache_update_ino()
> > > to all upper entries, similar to ovl_dir_read_impure().
> > >
> > > OR.. we can just do that unconditionally in ovl_iterate().
> > > The ovl dentry cache for the children will be populated after the first
> > > ovl_iterate() anyway, so maybe the penalty is not so bad?
> >
> > POSIX does allow stale readdir data (not just in case of non-zero seek):
> >
> > "If a file is removed from or added to the directory after the most
> > recent call to opendir() or rewinddir(), whether a subsequent call to
> > readdir() returns an entry for that file is unspecified."
> >
> > If you think about the way readdir(3) is implemented by the libc, this
> > is inevitable.
>
> I see. In that case, I would defer merging this test as it assumes too much
> about readdir behavior (even though applications may expect this behavior).

FWIW, I started writing a readdir stress/validator similar to
fsx-linux but for directories.

It's unfinished and  has performance problem as the directory grows
due to linear searches.

Putting it out in case someone wants to continue working on it, or
just take some ideas.

Thanks,
Miklos

--000000000000c2f54905c08bf388
Content-Type: text/x-csrc; charset="US-ASCII"; name="readdir-stress.c"
Content-Disposition: attachment; filename="readdir-stress.c"
Content-Transfer-Encoding: base64
Content-ID: <f_knsnp71v0>
X-Attachment-Id: f_knsnp71v0

LyoKICogQ29weXJpZ2h0IChDKSAyMDIxIE1pa2xvcyBTemVyZWRpIDxtaWtsb3NAc3plcmVkaS5o
dT4KICoKICogVGhpcyBwcm9ncmFtIGNhbiBiZSBkaXN0cmlidXRlZCB1bmRlciB0aGUgdGVybXMg
b2YgdGhlIEdOVSBHUEx2Mi4KICovCgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHVuaXN0
ZC5oPgojaW5jbHVkZSA8c3RkaW50Lmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPGZj
bnRsLmg+CiNpbmNsdWRlIDxkaXJlbnQuaD4KI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8
ZXJyLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8c3lzL3N5c2NhbGwuaD4KCnN0
cnVjdCBsaW51eF9kaXJlbnQ2NCB7Cgl1aW50NjRfdAlkX2lubzsKCWludDY0X3QJCWRfb2ZmOwoJ
dW5zaWduZWQgc2hvcnQJZF9yZWNsZW47Cgl1bnNpZ25lZCBjaGFyCWRfdHlwZTsKCWNoYXIJCWRf
bmFtZVswXTsKfTsKCnN0cnVjdCBlbnRyeSB7CgljaGFyICpuYW1lOwoJdW5zaWduZWQgY2hhciB0
eXBlOwoJaW5vX3QgaW5vOwoJaW50IGFkZF92ZXI7CglpbnQgZGVsX3ZlcjsKfTsKCnN0cnVjdCBs
aXN0X2VudHJ5IHsKCWNoYXIgKm5hbWU7Cgl1aW50NjRfdCBpbm87CglpbnQ2NF90IG9mZjsKCXVu
c2lnbmVkIGNoYXIgdHlwZTsKCWludCB2ZXJzaW9uOwoKCXN0cnVjdCBsaXN0X2VudHJ5ICpuZXh0
Owp9OwoKc3RydWN0IGRpciB7CglpbnQgZmQ7CglvZmZfdCBwb3M7CglpbnQgdmVyc2lvbjsKCXN0
cnVjdCBsaXN0X2VudHJ5ICpsaXN0Owp9OwoKc3RhdGljIHN0cnVjdCBkaXIgZ2xvYmFsX2RpcjsK
CnN0YXRpYyBpbnQgdmVyc2lvbiA9IDE7CnN0YXRpYyB1bnNpZ25lZCBpbnQgbnVtID0gMDsKc3Rh
dGljIHVuc2lnbmVkIGludCBudW1fYWN0aXZlID0gMDsKc3RhdGljIHN0cnVjdCBlbnRyeSAqYXJy
YXkgPSBOVUxMOwoKc3RhdGljIHZvaWQgKm9vbSh2b2lkICpwdHIpCnsKCWlmICghcHRyKQoJCWVy
cngoMSwgIm91dCBvZiBtZW1vcnkiKTsKCXJldHVybiBwdHI7Cn0KCnN0YXRpYyB2b2lkIGFkZF9l
bnRyeShjaGFyICpuYW1lLCB1bnNpZ25lZCBjaGFyIHR5cGUpCnsKCXN0cnVjdCBzdGF0IHN0OwoJ
aW50IHJlczsKCglyZXMgPSBsc3RhdChuYW1lLCAmc3QpOwoJaWYgKHJlcyA9PSAtMSkKCQllcnIo
MSwgImZhaWxlZCB0byBzdGF0IDwlcz4iLCBuYW1lKTsKCglhcnJheSA9IG9vbShyZWFsbG9jKGFy
cmF5LCAobnVtICsgMSkgKiBzaXplb2YoKmFycmF5KSkpOwoKCWFycmF5W251bV0ubmFtZSA9IG9v
bShzdHJkdXAobmFtZSkpOwoKCWFycmF5W251bV0udHlwZSA9IHR5cGU7CglhcnJheVtudW1dLmlu
byA9IHN0LnN0X2lubzsKCXZlcnNpb24rKzsKCWFycmF5W251bV0uYWRkX3ZlciA9IHZlcnNpb247
CglhcnJheVtudW1dLmRlbF92ZXIgPSAwOwoJbnVtKys7CgludW1fYWN0aXZlKys7Cn0KCnN0YXRp
YyBpbnQgY3JlYXRlX2VudHJ5KHZvaWQpCnsKCXVuc2lnbmVkIGNoYXIgdHlwZTsKCXVuc2lnbmVk
IGludCBuYW1lbGVuOwoJdW5zaWduZWQgaW50IGk7CgljaGFyIG5hbWVbMjU2XTsKCW1vZGVfdCBt
b2RlOwoJaW50IHJlczsKCgl0eXBlID0gKHJhbmRvbSgpICUgNykgKiAyOwoJaWYgKCF0eXBlKQoJ
CXR5cGUgPSAxOwoKCWlmICh0eXBlID09IERUX0NIUiB8fCB0eXBlID09IERUX0JMSykKCQl0eXBl
ID0gRFRfUkVHOwoKCW1vZGUgPSB0eXBlIDw8IDEyIHwgMDY2NjsKCnJldHJ5OgoJbmFtZWxlbiA9
IChyYW5kb20oKSAlIDEwKSA/IChyYW5kb20oKSAlIDMyICsgMSkgOiAocmFuZG9tKCkgJSAyMjIg
KyAzMyk7Ci8vCW5hbWVsZW4gPSByYW5kb20oKSAlIDMwICsgMTsKCglmb3IgKGkgPSAwOyBpIDwg
bmFtZWxlbjsgaSsrKSB7CgkJdW5zaWduZWQgY2hhciBjOwoKCQljID0gcmFuZG9tKCkgJSA5NCAr
IDMyOwoJCWlmIChjID49ICcvJykKCQkJYysrOwoJCW5hbWVbaV0gPSBjOwoJfQoJbmFtZVtuYW1l
bGVuXSA9ICdcMCc7CgoJaWYgKHN0cmNtcChuYW1lLCAiLiIpID09IDAgfHwgc3RyY21wKG5hbWUs
ICIuLiIpID09IDApCgkJZ290byByZXRyeTsKCglmb3IgKGkgPSAwOyBpIDwgbnVtOyBpKyspIHsK
CQlpZiAoc3RyY21wKG5hbWUsIGFycmF5W2ldLm5hbWUpID09IDApCgkJCWdvdG8gcmV0cnk7Cgl9
CgoJaWYgKFNfSVNESVIobW9kZSkpCgkJcmVzID0gbWtkaXIobmFtZSwgMDc3Nyk7CgllbHNlIGlm
IChTX0lTTE5LKG1vZGUpKQoJCXJlcyA9IHN5bWxpbmsoInRhcmdldCIsIG5hbWUpOwoJZWxzZQoJ
CXJlcyA9IG1rbm9kKG5hbWUsIG1vZGUsIDEpOwoKCWlmIChyZXMgPT0gLTEpCgkJZXJyKDEsICJm
YWlsZWQgdG8gY3JlYXRlIFwiJXNcIiwgbW9kZSAwJW8iLCBuYW1lLCBtb2RlKTsKCglhZGRfZW50
cnkobmFtZSwgdHlwZSk7CgoJcmV0dXJuIDA7Cn0KCnN0YXRpYyBpbnQgcmVtb3ZlX2VudHJ5KHZv
aWQpCnsKCXVuc2lnbmVkIGludCBpOwoJc3RydWN0IGVudHJ5ICp4OwoJaW50IHJlczsKCglpZiAo
IW51bV9hY3RpdmUpCgkJcmV0dXJuIDA7CnJldHJ5OgoJaSA9IHJhbmRvbSgpICUgbnVtOwoJeCA9
ICZhcnJheVtpXTsKCWlmICh4LT5kZWxfdmVyKQoJCWdvdG8gcmV0cnk7CgoJaWYgKHgtPnR5cGUg
PT0gRFRfRElSKQoJCXJlcyA9IHJtZGlyKHgtPm5hbWUpOwoJZWxzZQoJCXJlcyA9IHVubGluayh4
LT5uYW1lKTsKCWlmIChyZXMgPT0gLTEpCgkJZXJyKDEsICJmYWlsZWQgdG8gcmVtb3ZlIFwiJXNc
IiIsIHgtPm5hbWUpOwoKCXZlcnNpb24rKzsKCXgtPmRlbF92ZXIgPSB2ZXJzaW9uOwoJbnVtX2Fj
dGl2ZS0tOwoKCXJldHVybiAwOwp9CgpzdGF0aWMgdm9pZCBhZGRfbGlzdF9lbnRyeShzdHJ1Y3Qg
ZGlyICpkaXIsIHN0cnVjdCBsaXN0X2VudHJ5ICplbnQpCnsKCXN0cnVjdCBsaXN0X2VudHJ5ICoq
cHA7CgoJZm9yIChwcCA9ICZkaXItPmxpc3Q7ICpwcCAhPSBOVUxMOyBwcCA9ICYoKnBwKS0+bmV4
dCkgewoJCXN0cnVjdCBsaXN0X2VudHJ5ICpwID0gKnBwOwoKCQlpZiAoZW50LT5vZmYgPT0gcC0+
b2ZmKQoJCQllcnJ4KDEsICJ0d28gZW50cmllcyBoYXZlIHRoZSBzYW1lIG9mZnNldDogJWxpIiwK
CQkJCWVudC0+b2ZmKTsKCQlpZiAoc3RyY21wKGVudC0+bmFtZSwgcC0+bmFtZSkgPT0gMCkKCQkJ
ZXJyeCgxLCAidHdvIGVudHJpZXMgaGF2ZSB0aGUgc2FtZSBuYW1lIik7Cgl9CgkqcHAgPSBlbnQ7
Cn0KCnN0YXRpYyB2b2lkIGNoZWNrX2VudHJ5KHN0cnVjdCBkaXIgKmRpciwgc3RydWN0IGxpc3Rf
ZW50cnkgKmVudCkKewoJdW5zaWduZWQgaW50IGk7CgoJaWYgKHN0cmNtcChlbnQtPm5hbWUsICIu
IikgPT0gMCB8fCBzdHJjbXAoZW50LT5uYW1lLCAiLi4iKSA9PSAwKQoJCXJldHVybjsKCglmb3Ig
KGkgPSAwOyBpIDwgbnVtOyBpKyspIHsKCQlzdHJ1Y3QgZW50cnkgKnggPSAmYXJyYXlbaV07CgoJ
CWlmIChzdHJjbXAoZW50LT5uYW1lLCB4LT5uYW1lKSA9PSAwICYmCgkJICAgICgheC0+ZGVsX3Zl
ciB8fCB4LT5kZWxfdmVyID4gZGlyLT52ZXJzaW9uKSkgewoJCQlyZXR1cm47CgkJfQoJfQoJZXJy
eCgxLCAidW5rbm93biBlbnRyeSByZXR1cm5lZCBieSBnZXRkZW50czY0KCkgXCIlc1wiIiwgZW50
LT5uYW1lKTsKfQoKc3RhdGljIHZvaWQgY2hlY2tfY29tcGxldGUoc3RydWN0IGRpciAqZGlyKQp7
Cgl1bnNpZ25lZCBpbnQgaTsKCglmb3IgKGkgPSAwOyBpIDwgbnVtOyBpKyspIHsKCQlzdHJ1Y3Qg
ZW50cnkgKnggPSAmYXJyYXlbaV07CgoJCWlmICh4LT5hZGRfdmVyIDw9IGRpci0+dmVyc2lvbiAm
JiAheC0+ZGVsX3ZlcikgewoJCQlzdHJ1Y3QgbGlzdF9lbnRyeSAqcDsKCgkJCWZvciAocCA9IGRp
ci0+bGlzdDsgcDsgcCA9IHAtPm5leHQpIHsKCQkJCWlmIChzdHJjbXAoeC0+bmFtZSwgcC0+bmFt
ZSkgPT0gMCkKCQkJCQlicmVhazsKCQkJfQoJCQlpZiAoIXApIHsKCQkJCWVycngoMSwgIlwiJXNc
IiBub3QgZm91bmQgaW4gY29tcGxldGUgbGlzdGluZyIsCgkJCQkgICAgIHgtPm5hbWUpOwoJCQl9
CgkJfQoJfQp9CgpzdGF0aWMgaW50IHJlYWRfZGlyKHN0cnVjdCBkaXIgKmRpcikKewoJY2hhciBi
dWZbNjU1MzZdOwoJdW5zaWduZWQgaW50IHNpemUgPSByYW5kb20oKSAlIChzaXplb2YoYnVmKSAt
IDUxMikgKyA1MTI7CglpbnQgcmVzOwoJaW50IG5yZWFkOwoJc3RydWN0IGxpbnV4X2RpcmVudDY0
ICpkOwoJc3RydWN0IGxpc3RfZW50cnkgKmVudDsKCWludCBicG9zOwoJaW50IHZlcnNpb24gPSB2
ZXJzaW9uOwoKCXJlcyA9IHN5c2NhbGwoU1lTX2dldGRlbnRzNjQsIGRpci0+ZmQsIGJ1Ziwgc2l6
ZSk7CglpZiAocmVzID09IC0xKQoJCWVycigxLCAiZ2V0ZGVudHM2NCglaSwgJXAsICV1KSIsIGRp
ci0+ZmQsIGJ1Ziwgc2l6ZSk7CglucmVhZCA9IHJlczsKCglpZiAobnJlYWQgPT0gMCkgewoJCWNo
ZWNrX2NvbXBsZXRlKGRpcik7CgkJcmV0dXJuIDA7Cgl9CgoJZm9yIChicG9zID0gMDsgYnBvcyA8
IG5yZWFkOyApIHsKCQlkID0gKHN0cnVjdCBsaW51eF9kaXJlbnQ2NCAqKSAoYnVmICsgYnBvcyk7
CgoJCWVudCA9IG9vbShjYWxsb2MoMSwgc2l6ZW9mKCplbnQpKSk7CgkJZW50LT5uYW1lID0gb29t
KHN0cmR1cChkLT5kX25hbWUpKTsKCQllbnQtPmlubyA9IGQtPmRfaW5vOwoJCWVudC0+dHlwZSA9
IGQtPmRfdHlwZTsKCQllbnQtPm9mZiA9IGRpci0+cG9zOwoJCWVudC0+dmVyc2lvbiA9IHZlcnNp
b247CgkJZGlyLT5wb3MgPSBkLT5kX29mZjsKCgkJY2hlY2tfZW50cnkoZGlyLCBlbnQpOwoKCQlh
ZGRfbGlzdF9lbnRyeShkaXIsIGVudCk7CgoJCWJwb3MgKz0gZC0+ZF9yZWNsZW47Cgl9CglpZiAo
YnBvcyAhPSBucmVhZCkKCQllcnJ4KDEsICJpbnZhbGlkIHJlYWRkaXIgbGVuZ3RoIik7CgoJcmV0
dXJuIDA7Cn0KCnN0YXRpYyBpbnQgc2Vla19kaXIoc3RydWN0IGRpciAqZGlyKQp7CglvZmZfdCBy
ZXM7CglzdHJ1Y3QgbGlzdF9lbnRyeSAqcCwgKm5leHQ7CgoJZGlyLT52ZXJzaW9uID0gdmVyc2lv
bjsKCglyZXMgPSBsc2VlayhkaXItPmZkLCAwLCBTRUVLX1NFVCk7CglpZiAocmVzID09IChvZmZf
dCkgLTEpCgkJZXJyKDEsICJyZXdpbmQiKTsKCglmb3IgKHAgPSBkaXItPmxpc3Q7IHA7IHAgPSBu
ZXh0KSB7CgkJbmV4dCA9IHAtPm5leHQ7CgkJZnJlZShwLT5uYW1lKTsKCQlmcmVlKHApOwoJfQoJ
ZGlyLT5saXN0ID0gTlVMTDsKCWRpci0+cG9zID0gMDsKCglyZXR1cm4gMDsKfQoKc3RhdGljIGlu
dCBvbmUodm9pZCkKewoJc3dpdGNoIChyYW5kb20oKSAlIDEwKSB7CgljYXNlIDA6CgljYXNlIDE6
CgkJcmV0dXJuIGNyZWF0ZV9lbnRyeSgpOwoJY2FzZSAyOgoJCXJldHVybiByZW1vdmVfZW50cnko
KTsKCWNhc2UgMzoKCWNhc2UgNDoKCWNhc2UgNToKCWNhc2UgNjoKCWNhc2UgNzoKCWNhc2UgODoK
CQlyZXR1cm4gcmVhZF9kaXIoJmdsb2JhbF9kaXIpOwoJY2FzZSA5OgoJCXJldHVybiBzZWVrX2Rp
cigmZ2xvYmFsX2Rpcik7Cgl9CgllcnJ4KDEsICJ1bnJlYWNoYWJsZSIpOwp9CgpzdGF0aWMgaW50
IHJ1bih1bnNpZ25lZCBpbnQgaXRlcnMpCnsKCXVuc2lnbmVkIGludCBpOwoJaW50IHJlcyA9IDA7
CgoJc3JhbmRvbSgxKTsKCglnbG9iYWxfZGlyLnZlcnNpb24gPSB2ZXJzaW9uOwoJZ2xvYmFsX2Rp
ci5mZCA9IG9wZW4oIi4iLCBPX1JET05MWSB8IE9fRElSRUNUT1JZKTsKCWlmIChnbG9iYWxfZGly
LmZkID09IC0xKQoJCWVycigxLCAiZmFpbGVkIHRvIG9wZW4gXCIuXCIiKTsKCglmb3IgKGkgPSAw
OyBpIDwgaXRlcnM7IGkrKykgewoJCWlmIChpICUgMTAwID09IDEpCgkJCXByaW50ZigiWyVpXSB0
b3RhbCBlbnRyaWVzOiAldSBhY3RpdmUgZW50cmllczogJXVcbiIsCgkJCSAgICAgICBpLCBudW0s
IG51bV9hY3RpdmUpOwoJCXJlcyA9IG9uZSgpOwoJCWlmIChyZXMpCgkJCWJyZWFrOwoJfQoKCWNs
b3NlKGdsb2JhbF9kaXIuZmQpOwoKCXJldHVybiByZXM7Cn0KCmludCBtYWluKGludCBhcmdjLCBj
aGFyICphcmd2W10pCnsKCWNoYXIgKnRlc3RkaXIgPSBhcmd2WzFdOwoJaW50IHJlczsKCglpZiAo
YXJnYyA8IDIpCgkJZXJyeCgxLCAidXNhZ2U6ICVzIHRlc3RfZGlyZWN0b3J5IiwgYXJndlswXSk7
CgoJcmVzID0gY2hkaXIodGVzdGRpcik7CglpZiAocmVzID09IC0xKQoJCWVycigxLCAiY2hkaXIo
JXMpIiwgdGVzdGRpcik7CgoKCXJldHVybiBydW4oMTAwMDAwMCk7Cn0K
--000000000000c2f54905c08bf388--
