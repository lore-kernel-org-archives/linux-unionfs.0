Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793958026;
	b=fj0RXJqWXtgxx+e26qpScHdusMF4N3JBiKEg7UGiYkn9oaRO+EPM3j9xz3EdQleHwH6X
	 KpgJYa2tsQXFvDMD87y2ARK3zT6BaqAhpQiiLdZ4yKSa9ovctfLJt6LzhKPNQn8K5SGWc
	 FvVD8ElFwhcBHtsyuemADY69yuBM+EQ0s0oS/Yrhi0A3A5Gk8+WwbfMwEz9bdKtht0DF8
	 YUGVSdnU1/i4vTrCtepCIvikat+cIvL33UyFJczwVoLOIwvoJfCzqMNtDoJm2+Xm4xCS9
	 S4MdJ8iz+NvWWLwkAaa0HvMHmSZiCArggOP0llhZ6bvLBrrHfwzwpMecnkItQr4K1SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793958026;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IGwnMIps3aVHzaeShL2fgzkV216wL9LaoEnMk4sdS8M=;
	b=CrTsEWKNzu3f+CsEi/BSaR2WNQLg2ogNmu4qpHY2AL2AwX3q3fkC1zGfUmfOwaAkMpRz
	 qCailnY3C/h+HeJr0a5Dy9533sExPPMI1NajgfIFAppEqiFhd4mMRqAykI+0thLAfzSDc
	 8sScHEeFkX50J3eF31jtVQs0J9mSIQEukhy7uzhMoRXqkkJdavZxjochv/SxtGBcSpHIC
	 UxnrexZAUtIAPdcYXM0woBCFH3D+pYMLuT6yGxIbCQ2m+psFQ2mZjW4nvQ0pLMsIng768
	 WehHYOUa45sZnIyPfaxoUqpZA63a1lf1vWSGwS0DMMa9ZJybjcOpf0C4gBEfeL+7LxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=snLcgHsQ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=F8jmiAzz;
	arc=none smtp.remote-ip=103.168.172.152
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A63606A93F
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 09:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46A63606A93F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=snLcgHsQ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=F8jmiAzz
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8140C14000ED
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:40:24 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 06 Nov 2026 04:40:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1793958024;
	 x=1794044424; bh=IGwnMIps3aVHzaeShL2fgzkV216wL9LaoEnMk4sdS8M=; b=
	snLcgHsQAdVbagsmAvlo0vWU3Q6C8QFbxgXND4CsHHdp4+WoKStixENWW3PxNUdS
	7N0w1C96Ch7lvl7ABtYInIUkssy2FfMWf0NhyvvxKfDxjBAo1AelOgPj9yB+5/mT
	hKhQJZW6L+QB2NVLDsGnTDP1uTDMtGiFZv74LkA4oOq3aoYkJcsMIIwE/alSGKHe
	+NkPbVwKOpuf8F8PH0jWdkGBjjIlXRJOF3xuQfb6D3DpdEB/DUPeM7chxR7Dl+sY
	xQQ6G4wgR8hXCpeKeQBK8mAIHeecF3G8WnIuZwHw6Vyi8dlgzaaoOL1PSN8yrslw
	3+myPDPMx1gLaa88WfNqeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793958024; x=
	1794044424; bh=IGwnMIps3aVHzaeShL2fgzkV216wL9LaoEnMk4sdS8M=; b=F
	8jmiAzzcfMQSF600oU9hUe+ik+zlqAqngrtT+7evvvkuwGF2/vwBz+c90IyYc9Y8
	KQ8HH5VmNadApcdVMSZEyTGCNsX3zfn6Te0mvRZGE2FfZSu0s0rtrws02dpv8YgV
	J0bGGR/Lr7kSVuybveQMSaB+r9UFBZeV+f50G7csDNP0UEz3rEk3l73LcPp8C1r4
	g3UN6r6VvhDYyAJWp12wdG0MgLL+4Zp7BVDZxIhCycFGAcrcIBTBzTE0CyExy0nE
	equwPYK7vBjmPdZ3JvaZS0RYAWiAZszKrPaAD9u6RJcJ3r2U9lycO6J9YZbnzKEz
	EOkvGixNx1sJHp3uEgylA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793958024; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:xefYfISaF8M49wqmeFKh4t/TqJpwFT7E5JvitplubMA9GBW
	SOPSxQ4P63VVaR/Li7nmovrhouZmRUbG2pYVzUHrvjdLeBY9htOSacWzvsbmnOfW
	2Eridbsz2YAsLCdmrlrIQ9aIqhydoG6WpR9lL2bF6doHpe+oLavgYFeVoV134FYv
	jMyVzJ3wDj1w9wcPtMDzpF+CHzA0g2bqkeLv1tLpC9TNrcK6A7q7z+Wt2NjtG+vm
	K1sMcfwztFAchu04thNNE8rz8APLIUThAd6k9jKil7te/z4v1fdfGEWrZG+ZGIsv
	YawscM2mAzWwe+F4s5sG4BEqCgzxmGlWsAzEFCw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:SSsYshYfFr6bW4hCvqwgtD37KsTeXlCCGAGak7zC0iw=:TbIl05Yy5zCpSX2qGw2AVeBRs5K2m1dlYWCTqJkoCsA=;
X-ME-Sender: <xms:iKDtamFm7QMhkC1tto8aPZ1GzsVMeNHdbEcuLJB4RYsoDyINDk9iog>
    <xme:iKDtauy0TSdjpq-J0fKBIE8LLRwX8ywmL5Iwj9HMCysTZC1QA5uh64ij0jXz5l3nL
    6K1_SGo24nB_PjOO6nq8SDoRT6CHSyZVj-1p1A9lLBnZQm_6usk-iVi>
X-ME-Received: <xmr:iKDtatgYsDJm7n2T81nu6VGTu7kuViCuNPgkmeE6LZo2030fxJUBQr2gH1jMNxdWY5f1rVwIZhq_PI9JLtpMqGHds2TW>
X-ME-Proxy-Cause: dmFkZTFRI0clY9VQ7fRlNRQ/T4TACKqlkihzjANpLp8KcrdJLOU6YbC3cyaEJd81gvH5Tf
    XVgfo0IF9sc8NUgGqwkjkGMh+nJ9ehFTC3qXm8mr1oUH8u0cxMsKtp3MnIsBz67fq9EtAb
    Kqf0677wybNyAw6AlXfVbb+VkgcpA7qO4Y7GkZO1FgHGIP69IE35gEQWO1uHUUYrwRAUkm
    KpxaiXsdGSQg6rNhgNQ1uSXuXqixVcQAIj6HTPRsilLk3v9Pwr9fEJtqXkm7V5LuSdp7yD
    u/VwAghJ5rmx3QDrezWnY+RPb3SSdtl+08D5jI4o3rgv0dabVc01GgxsTUGuAmGDnMzYjx
    k0GEdWpttdn266u3SwqkOdmLa1vYmwm1FSYR77mwEk/SdScGAfP4VA4rBimNU1SyBEp4s4
    taHcXSxmbNOylApMQxU1mfV31W3nF0t3WXHXfrdiIdoqhrPqW89JgX5mjuKA0MhZCiogvf
    1mFMmrpgvpm7Slck4WIjjXRUA7YTmJVMKH/VsvIv0bnP63dZcKWTBr4NLnEvcXkIo3Cu49
    xhLTxity2qHxBT85cJlaElyvK8QRi0wMiyxynP3sIFtAxRaDjbvq9kyXuLPJ85pC4LHbqk
    MF1rhrMrls4WmPN+FeXShsG4aVB2CrrfstkrztTJAyylYXcLR6hqSZpUWNbA
X-ME-Proxy: <xmx:iKDtapwnN-uDDSmOL7A72S-gGqbc_ZjRJBut_kR0cAEdexPUqCYOSQ>
    <xmx:iKDtagKBQ-rZaLngh5Jxd8Y6ZjCLxihC2Tkd3voh6V7PcKKiC2xdog>
    <xmx:iKDtagQ7DxmunPscaGG6fcAvaWS3PWHLhEXGAk-t3j-HJ-kxJBfbvA>
    <xmx:iKDtaorCBKjezPcV_vi-CGLzGLgxuDuXciu54X7dB3akcaukawtDIA>
    <xmx:iKDtaiw-at-tQYxaKpDpmQEDiRRDetOHRSM6HS_SKzSMNY0FHO7lgQLp>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 04:40:23 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Subject: Re: [RFC][PATCH] overlay: always follow metacopy into data-only layers
In-Reply-To: <CAOQ4uxhmh7OpoGnNacFedBPm+jUQfDzv1QD4H+jTvb2kAPK=4Q@mail.gmail.com>
	(Amir Goldstein's message of "Fri, 6 Nov 2026 07:21:23 +0100")
References: <20261105143138.484820-1-giuseppe@scrivano.org>
	<CAOQ4uxhmh7OpoGnNacFedBPm+jUQfDzv1QD4H+jTvb2kAPK=4Q@mail.gmail.com>
Date: Fri, 06 Nov 2026 10:40:21 +0100
Message-ID: <87tslumh6i.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Amir,

Amir Goldstein <amir73il@gmail.com> writes:

> On Thu, Nov 5, 2026 at 3:37=E2=80=AFPM Giuseppe Scrivano <giuseppe@scriva=
no.org> wrote:
>>
>> A metacopy file with an absolute redirect to a data-only layer is follow=
ed
>> without metacopy=3Don and redirect_dir=3Don only when it is in the last =
lower
>> layer.  In any other lower layer, the next iteration of the loop in
>> ovl_lookup_layers() calls ovl_check_follow_redirect() with d->metacopy s=
et
>> and fails with -EPERM.
>>
>> A mount with userxattr cannot have metacopy=3Don and redirect_dir=3Don, =
so a
>> user namespace mount that stacks several metadata-only layers over a
>> data-only layer can use the metacopy files of the last lower layer only:
>>
>>   mount -t overlay none -o userxattr,lowerdir+=3Dl3,lowerdir+=3Dl2,\
>>         lowerdir+=3Dl1,datadir+=3Ddata,upperdir=3Du,workdir=3Dw m
>>   cat m/low   # metacopy file in l1: works
>>   cat m/mid   # metacopy file in l2: Operation not permitted
>>
>> Skip the check inside the loop for a metacopy file of a lower layer with=
 an
>> absolute redirect, on a mount that has data-only layers.  The lookup of =
the
>> data stays lazy and happens only in the data-only layers.  A metacopy fi=
le
>> or a redirect in the upper layer is still refused.  With metacopy=3Don a=
nd
>> redirect_dir=3Don the loop already continues after such a file, so only
>> mounts that failed with -EPERM are affected.
>>
>> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
>> ---
>>  fs/overlayfs/namei.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index ca899fdfaafd..02c64a5652a0 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -1087,6 +1087,14 @@ struct ovl_lookup_ctx {
>>         unsigned int ctr;
>>  };
>>
>> +/* A metacopy file of a lower layer whose lowerdata is in a data-only l=
ayer */
>> +static bool ovl_is_datalayer_redirect(struct ovl_lookup_ctx *ctx,
>> +                                     struct ovl_lookup_data *d)
>> +{
>> +       return d->metacopy && ctx->ctr && OVL_FS(d->sb)->numdatalayer &&
>> +              d->absolute_redirect;
>
> To further reduce risk, assuming that in the intended use case the data
> references always carry a digest, can we reinforce this to
> d->metacopy > OVL_METACOPY_MIN_SIZE?

I am not planning to use it only with fsverity.  I'd like to use this
also on file systems where fs-verity is not supported, or if an user
decides to opt-out for any reason.

>
>> +}
>> +
>>  static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_loo=
kup_data *d)
>>  {
>>         struct dentry *dentry =3D ctx->dentry;
>> @@ -1154,7 +1162,8 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx=
 *ctx, struct ovl_lookup_data
>>         for (i =3D 0; !d->stop && i < ovl_numlower(poe); i++) {
>>                 struct ovl_path lower =3D ovl_lowerstack(poe)[i];
>>
>> -               if (!ovl_check_follow_redirect(d)) {
>> +               if (!ovl_is_datalayer_redirect(ctx, d) &&
>> +                   !ovl_check_follow_redirect(d)) {
>>                         err =3D -EPERM;
>>                         return err;
>>                 }
>
> That's too promiscuous IMO to continue to loop as if nothing.
> You subject says "always follow metacopy into data-only layers"
> but this allows also following metacopy from l2 to l1 if there is a
> datalower and that makes no sense.
>
> What you would need to do is taint the lookup ctx in case we decided to
> follow against the follow_redirect/metacopy config in such a way
> that finding anything in the lower layers, even a whiteout or opaque
> object, will fail the lookup, because then we are not really allowing
> the intended follow into data-only layers.
>
> But I prefer to do it differently, see below
>
>> @@ -1238,7 +1247,7 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx=
 *ctx, struct ovl_lookup_data
>>          * Defer lookup of lowerdata in data-only layers to first access.
>>          * Don't require redirect=3Dfollow and metacopy=3Don in this cas=
e.
>>          */
>> -       if (d->metacopy && ctx->ctr && ofs->numdatalayer && d->absolute_=
redirect) {
>> +       if (ovl_is_datalayer_redirect(ctx, d)) {
>>                 d->metacopy =3D 0;
>>                 ctx->ctr++;
>>         } else if (!ovl_check_follow_redirect(d)) {
>> --
>> 2.56.0
>>
>>
>
> If the tooling can be changed we could introduce a special data-only
> follow marker and in this case we could just break out of the layers
> loop when it is encountered.
>
> Another option is to implement opt-in to redirect_dir=3Dfollowdata
> which only allows following absolute redirects to the data-only layers
> which will stop the layers loop on first found redirect and requires
> a data-only layer of course.
>
> I prefer this option if it meets the user case's needs,
> because verifying that the redirect doesn't redirect to a lower layer
> just complicates the code for a corner case and runs unneeded
> cycles for no good reason.

from an initial test, this seems to work for me.  If I don't encounter
other issues, I'll send another version later.

Thanks for your help!

Giuseppe
