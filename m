Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420ED3FE4;
	Mon, 26 Aug 2024 07:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724655632; cv=none; b=lejHzyvh2pLs8rzfP07gS0rFdZqRll6kivBgsDMjv3W8lcFL8qjy09A4ETpPZ3UJi0+szv8XdDKrFGKl5UppBaKFT1L+tCTa/shC5llMr7gQ6K0p16V40oV+ei7fID1f4Z30dYWc0826awX2Q86vVn3o95XuYbo2p5pkSVS9PcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724655632; c=relaxed/simple;
	bh=QbvLGkorMs2YBMtwGD1hxtKV6N4yNkWIvtA+plxFoHw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hWbbm3zOzkUi2HEsf5LUOzkhi512iMTibeefjHAzUtUL0Z0grRmM9+yhB6+wK3ftA+cYUPRDOfrL+YDlHwfSMjwJbgcUo2IQc/nuCIBiufhaP8gmkek744BQmYQ86KQLstvhE28DwuxriR6wWVkJlYgjijFkHiFg7zk7Bki3Cpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from spam.asrmicro.com (localhost [127.0.0.2] (may be forged))
	by spam.asrmicro.com with ESMTP id 47Q6uP35067674;
	Mon, 26 Aug 2024 14:56:25 +0800 (GMT-8)
	(envelope-from feilv@asrmicro.com)
Received: from mail2012.asrmicro.com (mail2012.asrmicro.com [10.1.24.123])
	by spam.asrmicro.com with ESMTPS id 47Q6u9Jq067648
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Mon, 26 Aug 2024 14:56:09 +0800 (GMT-8)
	(envelope-from feilv@asrmicro.com)
Received: from exch01.asrmicro.com (10.1.24.121) by mail2012.asrmicro.com
 (10.1.24.123) with Microsoft SMTP Server (TLS) id 15.0.847.32; Mon, 26 Aug
 2024 14:56:11 +0800
Received: from exch01.asrmicro.com ([::1]) by exch01.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Mon, 26 Aug 2024 14:56:11 +0800
From: =?utf-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
To: Amir Goldstein <amir73il@gmail.com>
CC: "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "linux-unionfs@vger.kernel.org"
	<linux-unionfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        =?utf-8?B?WHUgTGlhbmdode+8iOW+kOiJr+iZju+8iQ==?= <lianghuxu@asrmicro.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggVjJdIG92bDogZnN5bmMgYWZ0ZXIgbWV0YWRhdGEg?=
 =?utf-8?Q?copy-up_via_mount_option_"fsync=3Dstrict"?=
Thread-Topic: [PATCH V2] ovl: fsync after metadata copy-up via mount option
 "fsync=strict"
Thread-Index: AQHa9UIlKsA9M1EjHk6g0E/n5Hdt2rI0MnmAgATs23A=
Date: Mon, 26 Aug 2024 06:56:10 +0000
Message-ID: <5be64ae3b75e413fa47c9ecb2c4a359a@exch01.asrmicro.com>
References: <20240722101443.10768-1-feilv@asrmicro.com>
 <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAOQ4uxgbbadOC_LCYRk-muFKYH3QNVnD+ZEH+si-V1i3En66Bw@mail.gmail.com>
 <CAOQ4uxiDokEQ0ZET+adP_CpvvTCRRLTcVb9d5mYAmM1q7y2PnQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiDokEQ0ZET+adP_CpvvTCRRLTcVb9d5mYAmM1q7y2PnQ@mail.gmail.com>
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
X-MAIL:spam.asrmicro.com 47Q6uP35067674

DQoNCj4g5Y+R5Lu25Lq6OiBBbWlyIEdvbGRzdGVpbiBbbWFpbHRvOmFtaXI3M2lsQGdtYWlsLmNv
bV0gDQo+IOWPkemAgeaXtumXtDogMjAyNOW5tDjmnIgyM+aXpSAxOTo0Mw0KPiDmlLbku7bkuro6
IEx2IEZlae+8iOWQlemjnu+8iSA8ZmVpbHZAYXNybWljcm8uY29tPg0KPiDmioTpgIE6IG1pa2xv
c0BzemVyZWRpLmh1OyBsaW51eC11bmlvbmZzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsgWHUgTGlhbmdode+8iOW+kOiJr+iZju+8iSA8bGlhbmdodXh1QGFz
cm1pY3JvLj4gY29tPg0KPiDkuLvpopg6IFJlOiBbUEFUQ0ggVjJdIG92bDogZnN5bmMgYWZ0ZXIg
bWV0YWRhdGEgY29weS11cCB2aWEgbW91bnQgb3B0aW9uICJmc3luYz1zdHJpY3QiDQo+IA0KPiBP
biBGcmksIEF1ZyAyMywgMjAyNCBhdCAxMTo1MeKAr0FNIEFtaXIgR29sZHN0ZWluIDxhbWlyNzNp
bEBnbWFpbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gT24gTW9uLCBKdWwgMjIsIDIwMjQgYXQgMzo1
NuKAr1BNIEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+IHdyb3RlOg0KPiA+ID4N
Cj4gPiA+IE9uIE1vbiwgSnVsIDIyLCAyMDI0IGF0IDE6MTTigK9QTSBGZWkgTHYgPGZlaWx2QGFz
cm1pY3JvLmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IEZvciB1cHBlciBmaWxlc3lzdGVt
IHdoaWNoIGRvZXMgbm90IGVuZm9yY2Ugb3JkZXJpbmcgb24gc3RvcmluZyBvZiANCj4gPiA+ID4g
bWV0YWRhdGEgY2hhbmdlcyhlLmcuIHViaWZzKSwgd2hlbiBvdmVybGF5ZnMgZmlsZSBpcyBtb2Rp
ZmllZCBmb3IgDQo+ID4gPiA+IHRoZSBmaXJzdCB0aW1lLCBjb3B5IHVwIHdpbGwgY3JlYXRlIGEg
Y29weSBvZiB0aGUgbG93ZXIgZmlsZSBhbmQgDQo+ID4gPiA+IGl0cyBwYXJlbnQgZGlyZWN0b3Jp
ZXMgaW4gdGhlIHVwcGVyIGxheWVyLiBQZXJtaXNzaW9uIGxvc3Qgb2YgdGhlIA0KPiA+ID4gPiBu
ZXcgdXBwZXIgcGFyZW50IGRpcmVjdG9yeSB3YXMgb2JzZXJ2ZWQgZHVyaW5nIHBvd2VyLWN1dCBz
dHJlc3MgdGVzdC4NCj4gPiA+ID4NCj4gPiA+ID4gRml4IGJ5IGFkZGluZyBuZXcgbW91bnQgb3Bp
b24gImZzeW5jPXN0cmljdCIsIG1ha2Ugc3VyZSANCg0KVGhlcmUgaXMgYSB0eXBvIGhlcmUsICJv
cGlvbiIgc2hvdWxkIGJlICJvcHRpb24iLCBwbGVhc2UgaGVscCBjb3JyZWN0IGJlZm9yZSBtZXJn
ZS4NCg0KPiA+ID4gPiBkYXRhL21ldGFkYXRhIG9mIGNvcGllZCB1cCBkaXJlY3Rvcnkgd3JpdHRl
biB0byBkaXNrIGJlZm9yZSANCj4gPiA+ID4gcmVuYW1pbmcgZnJvbSB0bXAgdG8gZmluYWwgZGVz
dGluYXRpb24uDQo+ID4gPiA+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEZlaSBMdiA8ZmVpbHZA
YXNybWljcm8uY29tPg0KPiA+ID4NCj4gPiA+IFJldmlld2VkLWJ5OiBBbWlyIEdvbGRzdGVpbiA8
YW1pcjczaWxAZ21haWwuY29tPg0KPiA+ID4NCj4gPiA+IGJ1dCBJJ2QgYWxzbyBsaWtlIHRvIHdh
aXQgZm9yIGFuIEFDSyBmcm9tIE1pa2xvcyBvbiB0aGlzIGZlYXR1cmUuDQo+ID4gPg0KPiA+ID4g
QXMgZm9yIHRpbWluZywgd2UgYXJlIGluIHRoZSBtaWRkbGUgb2YgdGhlIG1lcmdlIHdpbmRvdyBm
b3IgDQo+ID4gPiA2LjExLXJjMSwgc28gd2UgaGF2ZSBzb21lIHRpbWUgYmVmb3JlIHRoaXMgY2Fu
IGJlIGNvbnNpZGVyZWQgZm9yIDYuMTIuDQo+ID4gPiBJIHdpbGwgYmUgb24gdmFjYXRpb24gZm9y
IG1vc3Qgb2YgdGhpcyBkZXZlbG9wbWVudCBjeWNsZSwgc28gZWl0aGVyIA0KPiA+ID4gTWlrbG9z
IHdpbGwgYmUgYWJsZSB0byBxdWV1ZSBpdCBmb3IgNi4xMiBvciBJIG1heSBiZSBhYmxlIHRvIGRv
IG5lYXIgDQo+ID4gPiB0aGUgZW5kIG9mIHRoZSA2LjExIGN5Y2xlLg0KPiA+ID4NCj4gPg0KPiA+
IE1pa2xvcywNCj4gPg0KPiA+IFBsZWFzZSBsZXQgbWUga25vdyB3aGF0IHlvdSB0aGluayBvZiB0
aGlzIGFwcHJvYWNoIHRvIGhhbmRsZSB1YmlmcyB1cHBlci4NCj4gPiBJZiB5b3UgbGlrZSBpdCwg
SSBjYW4gcXVldWUgdGhpcyB1cCBmb3IgdjYuMTIuDQo+ID4NCj4gPiBUaGFua3MsDQo+ID4gQW1p
ci4NCj4gPg0KPiA+ID4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+IFYxIC0+IFYyOg0KPiA+ID4gPiAg
MS4gY2hhbmdlIG9wZW4gZmxhZ3MgZnJvbSAiT19MQVJHRUZJTEUgfCBPX1dST05MWSIgdG8gIk9f
UkRPTkxZIi4NCj4gPiA+ID4gIDIuIGNoYW5nZSBtb3VudCBvcHRpb24gdG8gImZzeW5jPW9yZGVy
ZWQvc3RyaWN0L3ZvbGF0aWxlIi4NCj4gPiA+ID4gIDMuIG92bF9zaG91bGRfc3luY19zdHJpY3Qo
KSBpbXBsaWVzIG92bF9zaG91bGRfc3luYygpLg0KPiA+ID4gPiAgNC4gcmVtb3ZlIHJlZHVuZGFu
dCBvdmxfc2hvdWxkX3N5bmNfc3RyaWN0IGZyb20gb3ZsX2NvcHlfdXBfbWV0YV9pbm9kZV9kYXRh
Lg0KPiA+ID4gPiAgNS4gdXBkYXRlIGNvbW1pdCBsb2cuDQo+ID4gPiA+ICA2LiB1cGRhdGUgZG9j
dW1lbnRhdGlvbiBvdmVybGF5ZnMucnN0Lg0KPiA+ID4gPg0KPiANCj4gSGkgRmVpLA0KPiANCj4g
SSBzdGFydGVkIHRvIHRlc3QgdGhpcyBwYXRjaCBhbmQgaXQgb2NjdXJlZCB0byBtZSB0aGF0IHdl
IGhhdmUgbm8gdGVzdCBjb3ZlcmFnZSBmb3IgdGhlICJ2b2xhdGlsZSIgZmVhdHVyZS4NCj4gDQo+
IEZpbGVzeXN0ZW0gZHVyYWJpbGl0eSB0ZXN0cyBhcmUgbm90IGVhc3kgdG8gd3JpdGUgYW5kIEkg
a25vdyB0aGF0IHlvdSB0ZXN0ZWQgeW91ciBvd24gdXNlIGNhc2UsIHNvIEkgd2lsbCBub3QgYXNr
IHlvdSB0byB3cml0ZSBhIHJlZ3Jlc3Npb24gdGVzdCBhcyBhIGNvbmRpdGlvbiBmb3IgbWVyZ2Us
IGJ1dCBpZiB5b3UgYXJlIHdpbGxpbmcgdG8gaGVscCwgaXQgd291bGQgYmUgdmVyeSBuaWNlIHRv
IGFkZCB0aGlzIHRlc3QgY292ZXJhZ2UuDQoNCk9LLCBJIGNhbiBoYXZlIGEgdHJ5LCBuZWVkIHNv
bWUgdGltZSB0byBzdHVkeSB0ZXN0IHN1aXRlLiBUaGlzIGlzIGEgbmV3IHRoaW5nIGZvciBtZS4N
Cg0KPiANCj4gVGhlcmUgaXMgYWxyZWFkeSBvbmUgb3ZlcmxheWZzIHRlc3QgaW4gZnN0ZXN0cyAo
b3ZlcmxheS8wNzgpIHdoaWNoIHRlc3RzIGJlaGF2aW9yIG9mIG92ZXJsYXlmcyBjb3B5IHVwIGR1
cmluZyBwb3dlciBjdXQgKGEuay5hIHNodXRkb3duKS4NCg0KRG8geW91IG1lYW4gb3ZlcmxheS8w
NzggaW4ga2VybmVsL2dpdC9icmF1bmVyL3hmc3Rlc3RzLWRldi5naXQgPw0KDQo+IA0KPiBPbmUg
dGhpbmcgdGhhdCBJIGRvIHJlcXVlc3QgaXMgdGhhdCB5b3UgY29uZmlybSB0aGF0IHlvdSB0ZXN0
ZWQgdGhhdCB0aGUgbGVnYWN5ICJ2b2xhdGlsZSIgbW91bnQgb3B0aW9uIHN0aWxsIHdvcmtzIGFz
IGJlZm9yZS4NCg0KWWVzLCBJIHRlc3RlZCBiYXNpYyBmdW5jdGlvbiBvZiAidm9sYXRpbGUiIG1v
dW50IG9wdGlvbiB3aXRoIHRoaXMgcGF0Y2guDQoNCj4gSSBzYXcgdGhhdCB5b3UgdG9vayBjYXJl
IG9mIHByZXNlcnZpbmcgdGhlIGxlZ2FjeSBtb3VudCBvcHRpb24gaW4gZGlzcGxheSwgd2hpY2gg
aXMgZ29vZCBwcmFjdGljZS4NCj4gDQo+IFRoYW5rcywNCj4gQW1pci4NCg0KVGhhbmtzLA0KRmVp
DQo=
