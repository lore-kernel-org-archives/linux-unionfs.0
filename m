Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793889103;
	b=Tiu+6mcIz/xl8v1Va7jBolwfbN1KkS6p09tde+ND2eNqBlrPJAohdl4aN+Ki0wuugOBn
	 2w+bZaMS+tekX4CJSskil0DGjyVsqE93MhHOUp7vvSgiiXEesYm0LNk0309Q+Yv+GbwpE
	 D6VryItzvyRXgPbrFodIggEBrDMlHjubRtkoE/y7R7xMmMZDKeihfnPPiW+v38UUJ6nNb
	 saJt+QB7vV83Ebuhj68zaCax1/+iOnQoX89a5eLosGs4ukLbIY7/n9ujOXkWezRTlpRzh
	 J5UB6/glktyWzpwlsNa+rhjX3rqBZNvHkDrmRshb1/gi1OZO/xIR+i+2lSmrH6wmfgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793889103;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eqLXLxemSBllE3TpkKkslfTa4ooa7liYMqkGOwQgOsE=;
	b=1iervOLmP6K+pd39nzSaQqjq2d3gy246toToAqAxwbCzPNX1RyzB+FxjQ0qfFbAZ8iy2
	 Q+kL7b5W/Bu17WhkgCV5a78sBifDZFlaAPwcjeN7eTVmFUiwRDrdeQj5YxQu0iYxqpwUX
	 fOVT4VDDOdMYrJ7PO5iIILypnhYkhgy7IR+SUcovWX/orfSR8xk3l+TsqNZKfRI1YaIDX
	 oex+XxrJrvphR0+FWvkaC7RPNjzUKiVe5FLyPku4nl5wwsReHlecoWrFCXQ3RDTSohP3o
	 t2wIKpqPJZeSNJkApPEf1ASlLSFh1s1vrNY+PJ9jD1Im47rm0N6kh5sa8wK5P8bDW0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b="0/U50IKX";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=BLto8P1k;
	arc=none smtp.remote-ip=202.12.124.154
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E304C606A31B
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Nov 2026 14:31:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E304C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=0/U50IKX;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=BLto8P1k
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 12C707A011F
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Nov 2026 09:31:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 05 Nov 2026 09:31:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1793889101; x=1793975501; bh=eqLXLxemSBllE3TpkKksl
	fTa4ooa7liYMqkGOwQgOsE=; b=0/U50IKXHoWEuw2ZTghtDV9ZVFKD3H2RWr+un
	MJF/7ngSFy6etVIkvmuSwMFmgnQVCbnDZuswOMpll2kYlUqH/f4y8OzXAIJyo/Il
	u1sMKZzVFc0bWaz4FJ+Um2aTu6viKFmyBVYK7+1asKbvNcbHOFJt07dUkWiTlKZu
	FIeVfL52GVaw2MXONxy4+IyhNw8/5+2cXfLZajB6N72Y1i8KQeS97+i7z9An63QM
	GkYX2j7qNKmXiey1+/xMkAuO4pFkVnvMpv37vX2PyYd5/DgExLnceyIzBiOBy0MC
	01m1iN3kJ4uXkmlQbyzq0kolbEPkOO8mTo9Rd1mZJkxeMIgGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793889101; x=1793975501; bh=eqLXLxemSBllE3TpkKkslfTa4ooa7liYMqk
	GOwQgOsE=; b=BLto8P1kUtqIlALiuBVBGhAkcKZ3H6Vuxi7JslGNygw9vdKwK9F
	D+6MjslCzQGu5PhH08873hqkHd2tNa6Hrtgzhq25RSZCyI7j6pjO2j46nfbbjOCs
	empAOOB86Alg9NDDId0pH75Xp6VaTgJwDpRm9hOb+8SIEWf7w8WB/wfFG7CKjy7J
	VaAHShA7vmTkKHxULuWTCTUSAKr0UP8AZMCj26qpKgHtYCKtAJWtIhgW489e/Kzi
	AiRJGMwrZflfOA3X0F0tncLEQQpO/YLaDda1mJL2PShOSEQBB4GGla+YNR3ARfLq
	bFQy1ntDYiPQ0JQJGjOtlmKPoQkN6L3xylg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793889101; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:Q8sD51fuy7wq6lbgdemLelPf8ManFgd2Wtb3HsXzXrCLh7y
	xYJEeIKv4Sn6kv0FXo4YjkBO6Vs6x0m+zprFyvSdV+gC9DgRbtY8mVM/OZDuIZbR
	/4T3p+JELpF4SPuA0D99ZywR6v3FvRU7+Y2gvFwLK18NrIX57iDEaAl658pvOroe
	AOhAK+JQ5Y6wgcplSLOKAdCIat1Y5/JHBC4orMyp22QS6UiBP4MGT0moC1ZmNFSH
	sntPsu2nv2wmOg1+VRwK28+yJueIdpxxzUKjFXoX86+7f7zk1cUqtfdwzN9re9GT
	SuYKGTKkgdFBw1gX0nDh/EJeEE4TxvGDMiY1RXg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=8;
	hn=content-transfer-encoding,date,feedback-id,from,message-id,
	mime-version,subject,to;
Message-Instance: m=1; h=sha256:q26g5EhR0NBvUiSw6Aza3eWuP0D4BuhNnmVCIDzzcG8=:vPZAdqqSqnR6SifMQ5n2+sBgB+XOiA8S8CEuTSIzpD0=;
X-ME-Sender: <xms:TZPsapHkCA3wlB4Jz__MN_S0csskHDoAxhk8KbyzKn5wazc-FzqtKg>
    <xme:TZPsalSsb6ShtZpFfRUE54zjvpQn1oeRdCjOVoAWMfxo3D1Av2cxQ19_uKFkUDOZ0
    G9bz3TLQvwaFSNJ3IaC6WIBqsj4NcfmZsG_rrj6dDx-rocYyAs6HVE>
X-ME-Received: <xmr:TZPsagxD8olHrjsAP-CEmpdNNm0nni2olle9TKhKvshsm-r0MFept9vRgDtMc6vfYu5uESZaC1Tkxvmr2V6Hj3QZ1ztF>
X-ME-Proxy-Cause: dmFkZTGQiq+1Ze5bQoWedqfcR0UDOOK9iUwQo8CVKrL6GO6W0iG50T7KEz3+L1Pn1Tb8Hv
    MlDSWGkx7GQuZvwnAAY5ZKVI1LPu7S36E1Q3aeelo5kiP8w92UC1KcGAqOQIZkxs8ptVcU
    cAEpGjx0xSxCVLVqE/JFjwNg/5sHwW7I1oIP6T6P6SpwZGeiAx9NTQgTXDzB5kkCTA976E
    VNd/myrc+Q2TuAPpULEnGJmk12EyUFWZOZ9Th6AhPdJlfv0MnneskLwpDSIfmPteAmDnSa
    3quBIvZgJJ4uLWOVJRnBK2pQ9vvpVjLgA107e3JPDSF+anpSLg6RqYfzEceH1EG5UBGgHu
    F8IujowfC9cJmNAkZHyJ37266OO1HYFjtXKhl8CwT/tvHQi5hs0Dyu8QBLli1cxo6PGH6i
    rqDCc1lbBqqopHNa401kwGXNgSCkIPtUe8iqRp9tpiaBDUVEWZBvHofsBnXqCKioIwbZjQ
    649zOFT88bu8p2Zz5iaH7eFlQP8k71OI12i+fnUbIAAtFXsStAsIkoyAaWbCty+cYCoYVF
    fGHJrbfflmDRRtF/a+EO/8T+9Tzc1VP09eQx3eurtl7CcerMaVQpoLbpJhQgoGyRuR3pAd
    jsh5L1UIIMiQKuWpOiVvVBQp4nXCzQy2mMEDu9x+zKExiaho1bFSu7O1N7Tg
X-ME-Proxy: <xmx:TZPsakPV6AOryjTwwS0SFYlTcvf89M4jmkkdHlMm8JSR4Rg68PhdNw>
    <xmx:TZPsavP0pS7Y_fNkfvwohY90dFJ5EGBFJ7uS82Pz9s10JtccTmK4dg>
    <xmx:TZPsamSKakK9t6W-Bj8BDXLcgkAwEeZDwPbmHBfFS0d15Sl-_Y1iYA>
    <xmx:TZPsahDO4VrLSSibgQTs39bvSqhKVb-g3sm6NB_4yhUJuzwEy8zRTA>
    <xmx:TZPsanX7GPQxPJ71DunT55Xs4ITXh_XQWv-M7dxr5OuQV2-BFH83bLrE>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-unionfs@vger.kernel.org>; Thu, 5 Nov 2026 09:31:41 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: linux-unionfs@vger.kernel.org
Subject: [RFC][PATCH] overlay: always follow metacopy into data-only layers
Date: Thu,  5 Nov 2026 15:31:20 +0100
Message-ID: <20261105143138.484820-1-giuseppe@scrivano.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A metacopy file with an absolute redirect to a data-only layer is followed
without metacopy=on and redirect_dir=on only when it is in the last lower
layer.  In any other lower layer, the next iteration of the loop in
ovl_lookup_layers() calls ovl_check_follow_redirect() with d->metacopy set
and fails with -EPERM.

A mount with userxattr cannot have metacopy=on and redirect_dir=on, so a
user namespace mount that stacks several metadata-only layers over a
data-only layer can use the metacopy files of the last lower layer only:

  mount -t overlay none -o userxattr,lowerdir+=l3,lowerdir+=l2,\
        lowerdir+=l1,datadir+=data,upperdir=u,workdir=w m
  cat m/low   # metacopy file in l1: works
  cat m/mid   # metacopy file in l2: Operation not permitted

Skip the check inside the loop for a metacopy file of a lower layer with an
absolute redirect, on a mount that has data-only layers.  The lookup of the
data stays lazy and happens only in the data-only layers.  A metacopy file
or a redirect in the upper layer is still refused.  With metacopy=on and
redirect_dir=on the loop already continues after such a file, so only
mounts that failed with -EPERM are affected.

Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
---
 fs/overlayfs/namei.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ca899fdfaafd..02c64a5652a0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1087,6 +1087,14 @@ struct ovl_lookup_ctx {
 	unsigned int ctr;
 };
 
+/* A metacopy file of a lower layer whose lowerdata is in a data-only layer */
+static bool ovl_is_datalayer_redirect(struct ovl_lookup_ctx *ctx,
+				      struct ovl_lookup_data *d)
+{
+	return d->metacopy && ctx->ctr && OVL_FS(d->sb)->numdatalayer &&
+	       d->absolute_redirect;
+}
+
 static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data *d)
 {
 	struct dentry *dentry = ctx->dentry;
@@ -1154,7 +1162,8 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 	for (i = 0; !d->stop && i < ovl_numlower(poe); i++) {
 		struct ovl_path lower = ovl_lowerstack(poe)[i];
 
-		if (!ovl_check_follow_redirect(d)) {
+		if (!ovl_is_datalayer_redirect(ctx, d) &&
+		    !ovl_check_follow_redirect(d)) {
 			err = -EPERM;
 			return err;
 		}
@@ -1238,7 +1247,7 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 	 * Defer lookup of lowerdata in data-only layers to first access.
 	 * Don't require redirect=follow and metacopy=on in this case.
 	 */
-	if (d->metacopy && ctx->ctr && ofs->numdatalayer && d->absolute_redirect) {
+	if (ovl_is_datalayer_redirect(ctx, d)) {
 		d->metacopy = 0;
 		ctx->ctr++;
 	} else if (!ovl_check_follow_redirect(d)) {
-- 
2.56.0

