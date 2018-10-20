From: Richard Weinberger <richard@nod.at>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Date: Sat, 20 Oct 2018 08:58:49 +0200
Message-ID: <1818049.3sKzV5Nla8__34210.0760121413$1540018668$gmane$org@blindfold>
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <11759557.52cTf2r1oB@blindfold>
 <CACna6rzvf3+rL9x1uY2NrSd-OD_p08mhzY9hT6dpTOYseja_-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <CACna6rzvf3+rL9x1uY2NrSd-OD_p08mhzY9hT6dpTOYseja_-g@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Amir Goldstein <amir73il@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-mtd@lists.infradead.org, Russell Senior <russell@personaltelco.net>, linux-fsdevel@vger.kernel.org, OpenWrt Development List <openwrt-devel@lists.openwrt.org>
List-Id: linux-unionfs@vger.kernel.org

QW0gRnJlaXRhZywgMTkuIE9rdG9iZXIgMjAxOCwgMjM6Mjg6MzMgQ0VTVCBzY2hyaWViIFJhZmHF
giBNacWCZWNraToKPiBPbiBGcmksIDE5IE9jdCAyMDE4IGF0IDE2OjU5LCBSaWNoYXJkIFdlaW5i
ZXJnZXIgPHJpY2hhcmRAbm9kLmF0PiB3cm90ZToKPiA+IEFtIEZyZWl0YWcsIDE5LiBPa3RvYmVy
IDIwMTgsIDE2OjQ1OjUzIENFU1Qgc2NocmllYiBSaWNoYXJkIFdlaW5iZXJnZXI6Cj4gPiA+IFdl
bGwsIEkgZmVhciBpdCB1bmNvdmVycyBhIHByb2JsZW0gaW4gVUJJRlMuIFdlIGhhZCBhbHJlYWR5
IHByb2JsZW1zIHdpdGggb3ZlcmxheWZzLgo+ID4gPiBEaWQgeW91IGJpc2VjdCB0aGUgcHJvYmxl
bSBhbmQgeW91IGFyZSBzdXJlIHRoYXQgdGhlIHNhaWQgY29tbWl0IGlzIHRoZSBmaXJzdCBiYWQg
Y29tbWl0Pwo+ID4KPiA+IEFub3RoZXIgdGhpbmcsIFVCSUZTIGhhcyBubyBleHBvcnQgb3BlcmF0
aW9ucywgc28gb3ZlcmxheWZzIHdpbGwgZmFsbCBiYWNrIHRvIHhhdHRycywKPiA+IGlmIEkgcmVh
ZCB0aGUgY29tbWl0IGNvcnJlY3RseS4KPiA+IE1heWJlIHRoaXMgaXMgdGhlIHJvb3Qgb2YgdGhl
IHByb2JsZW0uCj4gPgo+ID4gSSdtIGN1cnJlbnRseSB0cmF2ZWxpbmcsIHNvIEkgY2Fubm90IHRl
c3QgbXVjaC4gUGxlYXNlIG1ha2Ugc3VyZSB3aGV0aGVyCj4gPiAzYTFlODE5YjRlODAgaXMgcmVh
bGx5IHRoZSBmaXJzdCBiYWQgY29tbWl0Lgo+ID4gVGhlbiBJIGNhbiBnbyBmb3IgYSBidWcgaHVu
dC4gOi0pCj4gCj4gSSBkaWQgYW5vdGhlciB0ZXN0IGFuZCBldmVyeXRoaW5nIGtlZXBzIHBvaW50
aW5nIHRvIHRoZSAzYTFlODE5YjRlODAuCj4gCj4gMSkgSSBzd2l0Y2hlZCB0byB0aGUgNC4xMi4x
NAo+IDIpIEkgY29uZmlybWVkIHByb2JsZW0gZXhpc3RzIHRoZXJlCj4gMykgSSBhZGRlZCAicmV0
dXJuIDA7IiBhdCB0aGUgYmVnaW5uaW5nIG9mIG92bF9zZXRfb3JpZ2luKCkKPiA0KSBJIGNvbmZp
cm1lZCBwcm9ibGVtIGRpc2FwcGVhcmVkCgpPa2F5LiBCdXQgSSBzdGlsbCB0aGluayB3ZSdyZSBm
YWNpbmcgc29tZSBVQklGUyBwcm9ibGVtLgoKVG8gZG91YmxlIGNoZWNrLCBvbiBMaW51eCA0LjEy
LjE0IHRoZSBwcm9ibGVtIGV4aXN0cyBhbmQgYnkgcmV2ZXJ0aW5nIDNhMWU4MTliNGU4MCAob3Ig
bWFraW5nIGl0IGEgbm9wKQppdCBnb2VzIGF3YXk/CkRvIHlvdSBzZWUgdGhlIHdhcm5pbmcgcmVn
YXJkaW5nIHRoZSBkb3VibGUgb3JwaGFuIG9ubHkgaW4gdGhlIGJhZCBjYXNlPwoKVGhhbmtzLAov
L3JpY2hhcmQKCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCkxpbnV4IE1URCBkaXNjdXNzaW9uIG1haWxpbmcgbGlzdApodHRwOi8vbGlzdHMu
aW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW10ZC8K
