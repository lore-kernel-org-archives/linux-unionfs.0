From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH] utimes: Clamp the timestamps in notify_change()
Date: Sun, 24 Nov 2019 13:14:04 -0800
Message-ID: <CABeXuvr3Xm+++hpo38jJLY_ZpELURV5p=egyAN9X6RtoDsm2JQ@mail.gmail.com>
References: <20191124193145.22945-1-amir73il@gmail.com>
 <20191124194934.GB4203@ZenIV.linux.org.uk>
 <CAOQ4uxjsOM+th1f4=wss4SCrwueUYuVT0FKX0GxtmHBG2juw+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAOQ4uxjsOM+th1f4=wss4SCrwueUYuVT0FKX0GxtmHBG2juw+A@mail.gmail.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Miklos Szeredi <miklos@szeredi.hu>, y2038 Mailman List <y2038@lists.linaro.org>, Jeff Layton <jlayton@kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

T24gU3VuLCBOb3YgMjQsIDIwMTkgYXQgMTI6NTAgUE0gQW1pciBHb2xkc3RlaW4gPGFtaXI3M2ls
QGdtYWlsLmNvbT4gd3JvdGU6Cj4KPiBPbiBTdW4sIE5vdiAyNCwgMjAxOSBhdCA5OjQ5IFBNIEFs
IFZpcm8gPHZpcm9AemVuaXYubGludXgub3JnLnVrPiB3cm90ZToKPiA+Cj4gPiBPbiBTdW4sIE5v
diAyNCwgMjAxOSBhdCAwOTozMTo0NVBNICswMjAwLCBBbWlyIEdvbGRzdGVpbiB3cm90ZToKPiA+
ID4gUHVzaCBjbGFtcGluZyB0aW1lc3RhbXBzIGRvd24gdGhlIGNhbGwgc3RhY2sgaW50byBub3Rp
ZnlfY2hhbmdlKCksIHNvCj4gPiA+IGluLWtlcm5lbCBjYWxsZXJzIGxpa2UgbmZzZCBhbmQgb3Zl
cmxheWZzIHdpbGwgZ2V0IHNpbWlsYXIgdGltZXN0YW1wCj4gPiA+IHNldCBiZWhhdmlvciBhcyB1
dGltZXMuCj4gPgo+ID4gTWFrZXMgc2Vuc2U7IHNhaWQgdGhhdCwgc2hvdWxkbid0IHdlIGdvIHRo
cm91Z2ggLT5zZXRhdHRyKCkgaW5zdGFuY2VzIGFuZAo+ID4gZ2V0IHJpZCBvZiB0aGF0IHRoZXJl
LCBub3cgdGhhdCBub3RpZnlfY2hhbmdlKCkgaXMgbWFkZSB0byBkbyBpdD8KPiA+Cj4KPiBTb3Vu
ZHMgcmVhc29uYWJsZS4gQnV0IEknZCByYXRoZXIgbGVhdmUgdGhpcyBjbGVhbnVwIHRvIERlZXBh
LAo+IHdobyBkaWQgYWxsIHRoaXMgd29yay4KClRoYW5rcywgSSBjYW4gcG9zdCBhIHBhdGNoIGZv
ciB0aGlzLgoKLURlZXBhCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8v
bGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
