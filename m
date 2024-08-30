Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3993214EC41;
	Fri, 30 Aug 2024 11:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725018754; cv=none; b=VrfuwDOfxnKqAMp5pHlGTLr7w0l2Ks7zVWNCvqGTGKYDbAA//DLhNqQLl9SW6b8Fy1/leAE0L2L1aaTHdoaljQw9s9TyblXSHw2LePsTBsO4mfjPqxluytKMOqQpxOdhndxLaDPYQbQvX75M8HjQcad7zsrwso3ZvXWfyqXuitY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725018754; c=relaxed/simple;
	bh=tkMaHixTKVYk7oLxmajD9jfS/nRBNt7By6UqI/vKOC4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dT1HX7HDCHUUruKBOpT/PFj9pFF1wEhK0CwsAhs4ZPyJBa3p6fe53z/ZU3eVWyTObZJFIC53JvxDvENrVKdLxK3yC3PTZupQlTju5+E8Fqb6c+9jmdHqux7HEedllY7LZhp0Vc35Q2RrfsqSOYGcPkEvIxiY3PUvRC7StLBymlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from mail2012.asrmicro.com (mail2012.asrmicro.com [10.1.24.123])
	by spam.asrmicro.com with ESMTPS id 47UBq8bb092868
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Fri, 30 Aug 2024 19:52:08 +0800 (GMT-8)
	(envelope-from feilv@asrmicro.com)
Received: from exch01.asrmicro.com (10.1.24.121) by mail2012.asrmicro.com
 (10.1.24.123) with Microsoft SMTP Server (TLS) id 15.0.847.32; Fri, 30 Aug
 2024 19:52:12 +0800
Received: from exch01.asrmicro.com ([::1]) by exch01.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Fri, 30 Aug 2024 19:52:12 +0800
From: =?utf-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
CC: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?WHUgTGlhbmdode+8iOW+kOiJr+iZju+8iQ==?= <lianghuxu@asrmicro.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggVjJdIG92bDogZnN5bmMgYWZ0ZXIgbWV0YWRhdGEg?=
 =?utf-8?Q?copy-up_via_mount_option_"fsync=3Dstrict"?=
Thread-Topic: [PATCH V2] ovl: fsync after metadata copy-up via mount option
 "fsync=strict"
Thread-Index: AQHa99DjKsA9M1EjHk6g0E/n5Hdt2rI6RY6AgANBbICAACeHgIAAOzeAgAEd/ACAAK4osA==
Date: Fri, 30 Aug 2024 11:52:11 +0000
Message-ID: <4ec356a473294dd3aab94a66c528eb2e@exch01.asrmicro.com>
References: <20240722101443.10768-1-feilv@asrmicro.com>
 <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com>
 <CAOQ4uxiYGsKzMZ73=WLZqseU=ibboFtPfqpeGtmFWYY3uxjMvw@mail.gmail.com>
 <CAOQ4uxi-BuKU-AbyydVB2c8z0DiPP-Ednu+bN3JB2Cqf7rZamA@mail.gmail.com>
 <CAJfpegt=BLfdb5GRbsOHheStve8S57V9XRDN_cNKcxst2dKZzw@mail.gmail.com>
 <CAOQ4uxhtoAL43d5HcVEsAH2EtgiT8h6RkjymNhTcP5nnG1h09g@mail.gmail.com>
 <CAOQ4uxjkVcY7z8JCshmsCfn1=JUcxDG8vyJQ+ssdeBmGrZ=eKg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjkVcY7z8JCshmsCfn1=JUcxDG8vyJQ+ssdeBmGrZ=eKg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 47UBq8bb092868

PiBPbiBUaHUsIEF1ZyAyOSwgMjAyNCBhdCA2OjIz4oCvUE0gQW1pciBHb2xkc3RlaW4gPGFtaXI3
M2lsQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiBUaHUsIEF1ZyAyOSwgMjAyNCBhdCAy
OjUx4oCvUE0gTWlrbG9zIFN6ZXJlZGkgPG1pa2xvc0BzemVyZWRpLmh1PiB3cm90ZToNCj4gPiA+
DQo+ID4gPiBPbiBUaHUsIDI5IEF1ZyAyMDI0IGF0IDEyOjI5LCBBbWlyIEdvbGRzdGVpbiA8YW1p
cjczaWxAZ21haWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiA+IEJ1dCBtYXliZSB3ZSBjYW4g
aWdub3JlIGNyYXNoIHNhZmV0eSBvZiBtZXRhY29weSBvbiB1YmlmcywgYmVjYXVzZSANCj4gPiA+
ID4gMS4gdGhlIHViaWZzIHVzZXJzIG1heSBub3QgYmUgdXNpbmcgdGhpcyBmZWF0dXJlIDIuIHVi
aWZzIG1heSBiZSANCj4gPiA+ID4gbmljZSBhbmQgdGFrZXMgY2FyZSBvZiBvcmRlcmluZyBPX1RN
UEZJTEUNCj4gPiA+ID4gICAgIG1ldGFkYXRhIHVwZGF0ZXMgYmVmb3JlIGV4cG9zaW5nIHRoZSBs
aW5rDQo+ID4gPiA+DQo+ID4gPiA+IFRoZW4gd2UgY2FuIGRvIHRoZSBmb2xsb3dpbmc6DQo+ID4g
PiA+IElGIChtZXRhY29weV9lbmFibGVkKQ0KPiA+ID4gPiAgICAgZnN5bmMgb25seSBpbiBvdmxf
Y29weV91cF9maWxlKCkgRUxTRQ0KPiA+ID4gPiAgICAgZnN5bmMgb25seSBpbiBvdmxfY29weV91
cF9tZXRhZGF0YSgpDQo+ID4gPiA+DQo+ID4gPiA+IExldCBtZSBrbm93IHdoYXQgeW91IHRoaW5r
Lg0KPiA+ID4NCj4gPiA+IFNvdW5kcyBsaWtlIGEgZ29vZCBjb21wcm9taXNlLg0KPiA+ID4NCj4g
Pg0KPiA+IEZlaSwNCj4gPg0KPiA+IENvdWxkIHlvdSBwbGVhc2UgdGVzdCB0aGUgYXR0YWNoZWQg
cGF0Y2ggYW5kIGNvbmZpcm0gdGhhdCB5b3VyIHVzZSANCj4gPiBjYXNlIGRvZXMgbm90IGRlcGVu
ZCBvbiBtZXRhY29weSBlbmFibGVkPw0KPiA+DQo+ID4gSW4gYW55IGNhc2UsIEkgYW0gaG9sZGlu
ZyBvbiB0byB5b3VyIHBhdGNoIGluIGNhc2Ugc29tZW9uZSByZXBvcnRzIGEgDQo+ID4gcGVyZm9y
bWFuY2UgcmVncmVzc2lvbiB3aXRoIHRoaXMgdW5jb25kaXRpb25hbCBmc3luYyBhcHByb2FjaC4N
Cj4gPg0KPiANCj4gV2VsbCwgaXQncyBhIGdvb2QgdGhpbmcgdGhhdCBJIHRvb2sgTWlrbG9pcycg
YWR2aWNlIHRvIG1ha2UgdGhlIGZzeW5jIG9wdGlvbiBpbXBsaWNpdCwgYmVjYXVzZSA+IHRoZSBv
cmlnaW5hbCBwYXRjaCBoYWQgMiBidWdzIGRldGVjdGVkIGJ5IGZzdGVzdDoNCj4gMS4gbWlzc2lu
ZyBPX0xBUkdFRklMRQ0KPiAyLiB0cnlpbmcgdG8gZnN5bmMgc3BlY2lhbCBmaWxlcw0KPiANCj4g
UGxlYXNlIHNlZSB1cHRvZGF0ZSBwYXRjaCBhdDoNCj4gaHR0cHM6Ly9naXRodWIuY29tL2FtaXI3
M2lsL2xpbnV4L2NvbW1pdHMvb3ZsLWZzeW5jLw0KPiANCj4gSWYgdGhlcmUgYXJlIG5vIGNvbXBs
YWludHMsIEkgd2lsbCBxdWV1ZSB0aGlzIHVwIGZvciB2Ni4xMi4NCj4gRmVpLCBwbGVhc2UgcHJv
dmlkZSB5b3VyIFRlc3RlZC1ieS4NCg0KV2UgZG8gbm90IGVuYWJsZSBtZXRhY29weS4NClRlc3Rl
ZCB0aGlzIHBhdGNoIGFuZCBpdCBhbHNvIHNvbHZlZCBvdXIgaXNzdWUuDQoNClRoYW5rcywNCkZl
aQ0KDQo=
