From: "Goetz, Patrick G" <pgoetz@math.utexas.edu>
Subject: Re: [PATCH] overlayfs: ignore empty NFSv4 ACLs in ext4 upperdir
Date: Thu, 2 May 2019 17:51:12 +0000
Message-ID: <31520294-b2cc-c1cb-d9c5-d3811e00939a@math.utexas.edu>
References: <CAJfpeguwUtRWRGmNmimNp-FXzWqMCCQMb24iWPu0w_J0_rOnnw@mail.gmail.com>
 <20161205151933.GA17517@fieldses.org>
 <CAJfpegtpkavseTFLspaC7svbvHRq-0-7jvyh63+DK5iWHTGnaQ@mail.gmail.com>
 <20161205162559.GB17517@fieldses.org>
 <CAHpGcMKHjic6L+J0qvMYNG9hVCcDO1hEpx4BiEk0ZCKDV39BmA@mail.gmail.com>
 <266c571f-e4e2-7c61-5ee2-8ece0c2d06e9@web.de>
 <CAHpGcMKmtppfn7PVrGKEEtVphuLV=YQ2GDYKOqje4ZANhzSgDw@mail.gmail.com>
 <CAHpGcMKjscfhmrAhwGes0ag2xTkbpFvCO6eiLL_rHz87XE-ZmA@mail.gmail.com>
 <CAJfpegvRFGOc31gVuYzanzWJ=mYSgRgtAaPhYNxZwHin3Wc0Gw@mail.gmail.com>
 <CAHc6FU4JQ28BFZE9_8A06gtkMvvKDzFmw9=ceNPYvnMXEimDMw@mail.gmail.com>
 <20161206185806.GC31197@fieldses.org>
 <87bm0l4nra.fsf@notabene.neil.brown.name>
 <CAOQ4uxjYEjqbLcVYoUaPzp-jqY_3tpPBhO7cE7kbq63XrPRQLQ@mail.gmail.com>
 <875zqt4igg.fsf@notabene.neil.brown.name>
 <8f3ba729-ed44-7bed-5ff8-b962547e5582@math.utexas.edu>
 <CAHc6FU4czPQ8xxv5efvhkizU3obpV_05VEWYKydXDDDYcp8j=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHc6FU4czPQ8xxv5efvhkizU3obpV_05VEWYKydXDDDYcp8j=w@mail.gmail.com>
Content-Language: en-US
Content-ID: <07CB6D9727B74B4EB8D9F2DD984EB149@namprd06.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Amir Goldstein <amir73il@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, =?utf-8?B?QW5kcmVhcyBHcsO8bmJhY2hlcg==?= <andreas.gruenbacher@gmail.com>, Patrick Plagwitz <Patrick_Plagwitz@web.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux NFS list <linux-nfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

DQoNCk9uIDUvMi8xOSAxMjo0NCBQTSwgQW5kcmVhcyBHcnVlbmJhY2hlciB3cm90ZToNCj4gT24g
VGh1LCAyIE1heSAyMDE5IGF0IDE5OjI3LCBHb2V0eiwgUGF0cmljayBHIDxwZ29ldHpAbWF0aC51
dGV4YXMuZWR1PiB3cm90ZToNCj4+IE9uIDUvMS8xOSAxMDo1NyBQTSwgTmVpbEJyb3duIHdyb3Rl
Og0KPj4+IFN1cHBvcnQgc29tZSBkYXkgc3VwcG9ydCBmb3IgbmZzNCBhY2xzIHdlcmUgYWRkZWQg
dG8gZXh0NCAobm90IGEgdG90YWxseQ0KPj4+IHJpZGljdWxvdXMgc3VnZ2VzdGlvbikuICBXZSB3
b3VsZCB0aGVuIHdhbnQgTkZTIHRvIGFsbG93IGl0J3MgQUNMcyB0byBiZQ0KPj4+IGNvcGllZCB1
cC4NCj4+DQo+PiBJcyB0aGVyZSBzb21lIHJlYXNvbiB3aHkgdGhlcmUgaGFzbid0IGJlZW4gYSBn
cmVhdGVyIGVmZm9ydCB0byBhZGQgTkZTdjQNCj4+IEFDTCBzdXBwb3J0IHRvIHRoZSBtYWluc3Ry
ZWFtIGxpbnV4IGZpbGVzeXN0ZW1zPyAgSSBoYXZlIHRvIHN1cHBvcnQgYQ0KPj4gaHlicmlkIGxp
bnV4L3dpbmRvd3MgZW52aXJvbm1lbnQgYW5kIG5vdCBoYXZpbmcgdGhlc2UgQUNMcyBvbiBleHQ0
IGlzIGENCj4+IGRhaWx5IGhlYWRhY2hlIGZvciBtZS4NCj4gDQo+IFRoZSBwYXRjaGVzIGZvciBp
bXBsZW1lbnRpbmcgdGhhdCBoYXZlIGJlZW4gcmVqZWN0ZWQgb3ZlciBhbmQgb3Zlcg0KPiBhZ2Fp
biwgYW5kIG5vYm9keSBpcyB3b3JraW5nIG9uIHRoZW0gYW55bW9yZS4NCj4gDQo+IEFuZHJlYXMN
Cj4gDQoNCg0KVGhhdCdzIHRoZSBwYXJ0IEkgZG9uJ3QgdW5kZXJzdGFuZCAtLSB3aHkgYXJlIHRo
ZSBSaWNoQUNMIHBhdGNoZXMgYmVpbmcgDQpyZWplY3RlZD8NCg0KRXZlcnlvbmUgbG92ZXMgdGhl
IHNpbXBsaWNpdHkgb2YgbW9kZSBiaXRzIChpbmNsdWRpbmcgbWUpIHVudGlsIHlvdSBydW4gDQpp
bnRvIHRoaW5ncyBsaWtlIHRoZSBuZWVkIHRvIGF1dG9tYXRpY2FsbHkgY3JlYXRlIGhvbWUgZGly
ZWN0b3JpZXMgb24gYW4gDQpORlMtbW91bnRlZCBmaWxlc3lzdGVtIG9yIHNlY3VyaXR5IHNpdHVh
dGlvbnMgd2hlcmUsIGZvciBleGFtcGxlLCB5b3UgDQp3YW50IHVzZXJzIHRvIGJlIGFibGUgdG8g
ZWRpdCBidXQgbm90IGRlbGV0ZSBmaWxlcywgYW5kIHRoZW4geW91J3JlIGtpbmQgDQpvZiBzdHVj
ayBsaXN0ZW5pbmcgdG8geW91ciBXaW5kb3dzIGNvbGxlYWd1ZXMgcHJvcG9zZSBhIFN0b3JhZ2Ug
U3BhY2VzIA0Kc29sdXRpb24uDQoNCg==
