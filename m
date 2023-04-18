Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AD9C77B75
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 11:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjDRLin (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 07:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjDRLim (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 07:38:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C43D525C
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 04:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681817854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kWwNf9yxSQBfnjlQZI/C13FbOBjHPqg84u2mRt3Txb4=;
        b=WQ16zZjbu1faOjneeU0vo1110+ik8E6QzqNdhL6bPOY/XZH7v8u4fSVOJTQVXoXBOv7Whb
        7No+f8FLhisOXC4FhHe3jVk+y1d9qU//q6UynLZnBLxBOLngdgvanvX1XDsBLg5wV8Insc
        GiORPrRdjG5xePgaQh+LUyX4MPHWchI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-YjluXeC8NnCemqkaeacSyA-1; Tue, 18 Apr 2023 07:37:33 -0400
X-MC-Unique: YjluXeC8NnCemqkaeacSyA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4ec893484caso848255e87.0
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 04:37:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681817851; x=1684409851;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kWwNf9yxSQBfnjlQZI/C13FbOBjHPqg84u2mRt3Txb4=;
        b=Rq+EAnPI0wEIp/EzcLLgxrRFVQNmhFD8pxVafgPqvSuT94E8oFrewcKrHxW3pLKhIa
         aMEizAWXlM5qCeuhvT49SRPJkMkwHTqH/AcWZU0+cEe1WI7Fb6IVfWAuI2aDUa5yEvcv
         /4MD4/Cy3lilYv4u/pK+rme52hPNYznApy+zQI2WQtR+pcIXLQ1r5QQYIa8f+Kax0SNQ
         r1ZEZvvyotsUo4eE4zB83J9USBBUgHGQo2OEwbqwMP6NdIct0nQTmImpV8n+H9sZhCvb
         tY5QCoYNO5WPtkp6BBA0StiZcGQ2xEamsgTH9Y+Fi/khN7eUKIrBH5aA17gD6X3Btufx
         5UCQ==
X-Gm-Message-State: AAQBX9fE6GzgnArSYeWHpMFubPvcVwBi7EKrRN8l2N4eGCZPQWg/GnS1
        iYrEc7kgF2tUJpB+AUBf5mQAWzm8eWtXc0ARyufhq8GUrG/C7Y8pv7UQTat875ErqzPnbAGaoCL
        SCxO4T2BYAhnXqcy6aKtc090PUg==
X-Received: by 2002:ac2:5598:0:b0:4ea:e799:59f9 with SMTP id v24-20020ac25598000000b004eae79959f9mr2891980lfg.66.1681817851661;
        Tue, 18 Apr 2023 04:37:31 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z78YtI+B/Jr2vSSTxgYk2CqqhPUW1DaOwY/pQKdCRthyGRHEDC3+DsbaAXgW7HX2ywfzgNag==
X-Received: by 2002:ac2:5598:0:b0:4ea:e799:59f9 with SMTP id v24-20020ac25598000000b004eae79959f9mr2891973lfg.66.1681817851374;
        Tue, 18 Apr 2023 04:37:31 -0700 (PDT)
Received: from greebo.mooo.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.gmail.com with ESMTPSA id d11-20020ac241cb000000b004ec834cc59fsm2332841lfi.267.2023.04.18.04.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 04:37:30 -0700 (PDT)
Message-ID: <9b68923f1a0c1d80b159adb981661bc5c9c58235.camel@redhat.com>
Subject: Re: [PATCH 1/5] ovl: remove unneeded goto instructions
From:   Alexander Larsson <alexl@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Date:   Tue, 18 Apr 2023 13:37:30 +0200
In-Reply-To: <20230412135412.1684197-2-amir73il@gmail.com>
References: <20230412135412.1684197-1-amir73il@gmail.com>
         <20230412135412.1684197-2-amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTEyIGF0IDE2OjU0ICswMzAwLCBBbWlyIEdvbGRzdGVpbiB3cm90ZToK
PiBUaGVyZSBpcyBub3RoaW5nIGluIHRoZSBvdXQgZ290byB0YXJnZXQgb2Ygb3ZsX2dldF9sYXll
cnMoKS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwu
Y29tPgoKTEdUTQoKUmV2aWV3ZWQtYnk6IEFsZXhhbmRlciBMYXJzc29uIDxhbGV4bEByZWRoYXQu
Y29tPgoKPiAtLS0KPiDCoGZzL292ZXJsYXlmcy9zdXBlci5jIHwgMjEgKysrKysrKysrLS0tLS0t
LS0tLS0tCj4gwqAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMo
LSkKPiAKPiBkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZzL3N1cGVyLmMgYi9mcy9vdmVybGF5ZnMv
c3VwZXIuYwo+IGluZGV4IDZlNDIzMTc5OWI4Ni4uNzc0MmFlZjNmM2IzIDEwMDY0NAo+IC0tLSBh
L2ZzL292ZXJsYXlmcy9zdXBlci5jCj4gKysrIGIvZnMvb3ZlcmxheWZzL3N1cGVyLmMKPiBAQCAt
MTU4NiwxMCArMTU4Niw5IEBAIHN0YXRpYyBpbnQgb3ZsX2dldF9sYXllcnMoc3RydWN0IHN1cGVy
X2Jsb2NrCj4gKnNiLCBzdHJ1Y3Qgb3ZsX2ZzICpvZnMsCj4gwqDCoMKgwqDCoMKgwqDCoGludCBl
cnI7Cj4gwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCBpOwo+IMKgCj4gLcKgwqDCoMKgwqDC
oMKgZXJyID0gLUVOT01FTTsKPiDCoMKgwqDCoMKgwqDCoMKgb2ZzLT5mcyA9IGtjYWxsb2MobnVt
bG93ZXIgKyAxLCBzaXplb2Yoc3RydWN0IG92bF9zYiksCj4gR0ZQX0tFUk5FTCk7Cj4gwqDCoMKg
wqDCoMKgwqDCoGlmIChvZnMtPmZzID09IE5VTEwpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGdvdG8gb3V0Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
LUVOT01FTTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqAvKiBpZHgvZnNpZCAwIGFyZSByZXNlcnZl
ZCBmb3IgdXBwZXIgZnMgZXZlbiB3aXRoIGxvd2VyIG9ubHkKPiBvdmVybGF5ICovCj4gwqDCoMKg
wqDCoMKgwqDCoG9mcy0+bnVtZnMrKzsKPiBAQCAtMTYwMyw3ICsxNjAyLDcgQEAgc3RhdGljIGlu
dCBvdmxfZ2V0X2xheWVycyhzdHJ1Y3Qgc3VwZXJfYmxvY2sKPiAqc2IsIHN0cnVjdCBvdmxfZnMg
Km9mcywKPiDCoMKgwqDCoMKgwqDCoMKgZXJyID0gZ2V0X2Fub25fYmRldigmb2ZzLT5mc1swXS5w
c2V1ZG9fZGV2KTsKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycikgewo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcHJfZXJyKCJmYWlsZWQgdG8gZ2V0IGFub255bW91cyBiZGV2IGZv
ciB1cHBlcgo+IGZzXG4iKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBv
dXQ7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBlcnI7Cj4gwqDCoMKg
wqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAob3ZsX3VwcGVyX21udChvZnMp
KSB7Cj4gQEAgLTE2MTYsOSArMTYxNSw5IEBAIHN0YXRpYyBpbnQgb3ZsX2dldF9sYXllcnMoc3Ry
dWN0IHN1cGVyX2Jsb2NrCj4gKnNiLCBzdHJ1Y3Qgb3ZsX2ZzICpvZnMsCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaW5vZGUgKnRyYXA7Cj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBpbnQgZnNpZDsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBlcnIgPSBmc2lkID0gb3ZsX2dldF9mc2lkKG9mcywgJnN0YWNrW2ldKTsKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGVyciA8IDApCj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dDsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZnNpZCA9IG92bF9nZXRfZnNpZChvZnMsICZzdGFja1tpXSk7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChmc2lkIDwgMCkKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBmc2lkOwo+IMKgCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICogQ2hlY2sgaWYgbG93ZXIgcm9vdCBjb25mbGljdHMgd2l0aCB0aGlzIG92
ZXJsYXkKPiBsYXllcnMgYmVmb3JlCj4gQEAgLTE2MjksMTMgKzE2MjgsMTMgQEAgc3RhdGljIGlu
dCBvdmxfZ2V0X2xheWVycyhzdHJ1Y3Qgc3VwZXJfYmxvY2sKPiAqc2IsIHN0cnVjdCBvdmxfZnMg
Km9mcywKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyID0gb3ZsX3NldHVwX3RyYXAoc2IsIHN0YWNrW2ldLmRl
bnRyeSwgJnRyYXAsCj4gImxvd2VyZGlyIik7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpZiAoZXJyKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZ290byBvdXQ7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gZXJyOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBpZiAob3ZsX2lzX2ludXNlKHN0YWNrW2ldLmRlbnRyeSkpIHsKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnIgPSBvdmxfcmVwb3J0X2luX3VzZShv
ZnMsICJsb3dlcmRpciIpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGlmIChlcnIpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaXB1dCh0cmFwKTsKPiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91
dDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gZXJyOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoH0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDC
oAo+IEBAIC0xNjQ0LDcgKzE2NDMsNyBAQCBzdGF0aWMgaW50IG92bF9nZXRfbGF5ZXJzKHN0cnVj
dCBzdXBlcl9ibG9jawo+ICpzYiwgc3RydWN0IG92bF9mcyAqb2ZzLAo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgaWYgKElTX0VSUihtbnQpKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcHJfZXJyKCJmYWlsZWQgdG8gY2xvbmUgbG93
ZXJwYXRoXG4iKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpcHV0KHRyYXApOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgZ290byBvdXQ7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gZXJyOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
fQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKgo+IEBAIC0xNjk0LDkg
KzE2OTMsNyBAQCBzdGF0aWMgaW50IG92bF9nZXRfbGF5ZXJzKHN0cnVjdCBzdXBlcl9ibG9jawo+
ICpzYiwgc3RydWN0IG92bF9mcyAqb2ZzLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoG9mcy0+eGlub19tb2RlKTsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+
IMKgCj4gLcKgwqDCoMKgwqDCoMKgZXJyID0gMDsKPiAtb3V0Ogo+IC3CoMKgwqDCoMKgwqDCoHJl
dHVybiBlcnI7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gwqB9Cj4gwqAKPiDCoHN0YXRp
YyBpbnQgb3ZsX2dldF9sb3dlcnN0YWNrKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdAo+
IG92bF9lbnRyeSAqb2UsCgotLSAKPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0t
PS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LQo9LT0tPQogQWxleGFuZGVyIExhcnNz
b24gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFJlZCBIYXQsCklu
YyAKICAgICAgIGFsZXhsQHJlZGhhdC5jb20gICAgICAgICAgICBhbGV4YW5kZXIubGFyc3NvbkBn
bWFpbC5jb20gCkhlJ3MgYSBtYXZlcmljayBzaGFyay13cmVzdGxpbmcgcm9tYW5jZSBub3ZlbGlz
dCBpbiBhIHdoZWVsY2hhaXIuIFNoZSdzCmEgCm1hbmlwdWxhdGl2ZSBueW1waG9tYW5pYWMgSGVs
bCdzIEFuZ2VsIHdpdGggYSBiaXJ0aG1hcmsgc2hhcGVkIGxpa2UgCkxpYmVydHkncyB0b3JjaC4g
VGhleSBmaWdodCBjcmltZSEgCg==

